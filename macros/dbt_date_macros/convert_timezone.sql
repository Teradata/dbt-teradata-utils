{%- macro teradata__convert_timezone(column, target_tz=None, source_tz=None) -%}
    {%- if source_tz == 'UTC' -%}
      {% set source_tz = 'GMT' %}
    {%- endif -%}
    CAST(
        (CAST({{ column }} AS {{ dbt.type_timestamp() }}) AT TIME ZONE '{{ source_tz or "GMT" }}') 
        AT TIME ZONE '{{ target_tz }}'
    AS {{ dbt.type_timestamp() }})
{%- endmacro -%}