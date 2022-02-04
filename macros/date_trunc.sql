

{% macro teradata__date_trunc(datepart, date) %}
    extract({{datepart}} FROM {{date}})
{% endmacro %}
