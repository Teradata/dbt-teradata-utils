{# Overriding because the original implementation used 'numeric' type to force float output. numeric in Teradata defaults to integer #}
{# You have specify precision, to get a float, e.g. numeric(5,2) #}

{% macro teradata__test_not_null_proportion(model) %}

{% set column_name = kwargs.get('column_name', kwargs.get('arg')) %}
{% set at_least = kwargs.get('at_least', kwargs.get('arg')) %}
{% set at_most = kwargs.get('at_most', kwargs.get('arg', 1)) %}

WITH validation AS (
  SELECT
    sum(CASE WHEN {{ column_name }} iS NULL THEN 0 ELSE 1 END) / cast(count(*) AS numeric(5,2)) AS not_null_proportion
  from {{ model }}
),
validation_errors AS (
  SELECT
    not_null_proportion
  FROM validation
  WHERE not_null_proportion < {{ at_least }} OR not_null_proportion > {{ at_most }}
)
SELECT
  *
FROM validation_errors

{% endmacro %}
