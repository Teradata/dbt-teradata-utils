{# Overriding because the original implementation used dateadd() function which is not supported in Teradata #}

{% macro teradata__dateadd(datepart, interval, from_date_or_timestamp) %}
  {{from_date_or_timestamp}}  + cast(sign({{interval}}) AS INT) * cast(abs({{ interval }}) AS INTERVAL {{datepart}}(4))
{% endmacro %}
