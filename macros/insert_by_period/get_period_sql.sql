{% macro get_period_sql(target_cols_csv, sql, timestamp_field, period, start_timestamp, stop_timestamp, offset) -%}

  {%- set period_filter -%}
    ({{timestamp_field}} >  cast('{{start_timestamp}}' as timestamp) + interval '{{offset}}' {{period}} and
     {{timestamp_field}} <= cast('{{start_timestamp}}' as timestamp) + interval '{{offset}}' {{period}} + interval '1' {{period}} and
     {{timestamp_field}} <  cast('{{stop_timestamp}}' as timestamp))
  {%- endset -%}

  {%- set filtered_sql = sql | replace("__PERIOD_FILTER__", period_filter) -%}

  select
    {{target_cols_csv}}
  from (
    {{filtered_sql}}
  ) target_cols

{%- endmacro %}