{# Overriding because the original implementation used dateadd() function which is not supported in Teradata #}
{% macro teradata__dateadd(datepart, interval, from_date_or_timestamp) %}
  {{ from_date_or_timestamp }}
  {%- if interval > 0 -%}
    +
  {%- else -%}
    -
  {%- endif -%}
   Interval '{{ interval|abs }}' {{ datepart }}
{% endmacro %}
