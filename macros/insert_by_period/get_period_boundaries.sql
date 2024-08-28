{% macro get_period_boundaries(target_schema, target_table, timestamp_field, start_date, stop_date, period, backfill, full_refresh_mode) -%}

  {% call statement('period_boundaries', fetch_result=True) -%}
    with data as (
      select
          {% if backfill and not full_refresh_mode -%}
          cast(coalesce(trycast('{{start_date}}' as date), cast('{{start_date}}' as timestamp)) as timestamp) as start_timestamp,
          {%- else -%}
          coalesce(max({{timestamp_field}}), cast(coalesce(trycast('{{start_date}}' as date), cast('{{start_date}}' as timestamp)) as timestamp)) as start_timestamp,
          {%- endif %}
          prior(coalesce(cast(coalesce(trycast(nullif('{{stop_date}}','') as date), cast(nullif('{{stop_date}}','') as timestamp)) as timestamp), {{ dbt.current_timestamp() }})) as stop_timestamp
      from {{adapter.quote(target_schema)}}.{{adapter.quote(target_table)}}
    )

    select
      start_timestamp,
      stop_timestamp,
      ({{ datediff('start_timestamp',
                           'stop_timestamp',
                           period) }})  + INTERVAL '1' {{ period }} as num_periods
    from data
  {%- endcall %}

{%- endmacro %}