{# Overriding because the original implementation used 'numeric' type to force float output. numeric in Teradata defaults to integer #}
{# You have specify precision, to get a float, e.g. numeric(5,2) #}

{% macro teradata__test_not_null_proportion(model, group_by_columns) %}

{% set column_name = kwargs.get('column_name', kwargs.get('arg')) %}
{% set at_least = kwargs.get('at_least', kwargs.get('arg')) %}
{% set at_most = kwargs.get('at_most', kwargs.get('arg', 1)) %}

{% if group_by_columns|length() > 0 %}
  {% set select_gb_cols = group_by_columns|join(' ,') + ', ' %}
  {% set groupby_gb_cols = 'group by ' + group_by_columns|join(',') %}
{% endif %}

WITH validation AS (
  SELECT
    sum(CASE WHEN {{ column_name }} iS NULL THEN 0 ELSE 1 END) / cast(count(*) AS numeric(5,2)) AS not_null_proportion
  from {{ model }}
  {{groupby_gb_cols}}
),
validation_errors AS (
  SELECT
    {{select_gb_cols}}
    not_null_proportion
  FROM validation
  WHERE not_null_proportion < {{ at_least }} OR not_null_proportion > {{ at_most }}
)
SELECT
  *
FROM validation_errors

{% endmacro %}
