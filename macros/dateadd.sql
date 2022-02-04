{# Overriding because the original implementation used dateadd() function which is not supported in Teradata #}

{% macro teradata__dateadd(datepart, interval, from_date_or_timestamp) %}
  {% set type='DATE' %}
  {% if datepart|upper in ( 'HOUR', 'MINUTE' ) %}
    {% set type='TIMESTAMP(0)' %}
  {% endif %}
  cast({{from_date_or_timestamp}} AS {{type}})  + cast(sign({{interval}}) AS INT) * cast(abs({{ interval }}) AS INTERVAL {{datepart}}(4))
{% endmacro %}
