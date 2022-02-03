{% macro teradata__datediff(first_date, second_date, datepart) %}
  ({{ second_date }} - {{ first_date }}) {{ datepart }}(4)
{% endmacro %}
