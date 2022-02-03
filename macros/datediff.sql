{# This macro needed to be overridden because the original implementation #}
{# used 'datediff' function that is not supported on Vantage #}

{% macro teradata__datediff(first_date, second_date, datepart) %}
  ({{ second_date }} - {{ first_date }}) {{ datepart }}(4)
{% endmacro %}
