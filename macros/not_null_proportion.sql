{# Overriding because the original implementation used 'numeric' type to force float output. numeric in Teradata defaults to integer #}
{# You have specify precision, to get a float, e.g. numeric(5,2) #}
{% macro teradata__test_not_null_proportion(model) %}

{% set column_name = kwargs.get('column_name', kwargs.get('arg')) %}
{% set at_least = kwargs.get('at_least', kwargs.get('arg')) %}
{% set at_most = kwargs.get('at_most', kwargs.get('arg', 1)) %}

with validation as (
  select
    sum(case when {{ column_name }} is null then 0 else 1 end) / cast(count(*) as numeric(5,2)) as not_null_proportion
  from {{ model }}
),
validation_errors as (
  select
    not_null_proportion
  from validation
  where not_null_proportion < {{ at_least }} or not_null_proportion > {{ at_most }}
)
select
  *
from validation_errors

{% endmacro %}
