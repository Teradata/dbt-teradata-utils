{% macro teradata__get_base_dates(start_date, end_date, n_dateparts, datepart) %}

    {%- if start_date and end_date -%}
        {%- if datepart == 'day' -%}
            {# For day-level granularity, cast string -> DATE -> TIMESTAMP to avoid "Invalid timestamp" errors #}
            {%- set start_date = (
                "cast(cast('" ~ start_date ~ "' as date) as " ~ dbt.type_timestamp() ~ ")"
            ) -%}
            {%- set end_date = (
                "cast(cast('" ~ end_date ~ "' as date) as " ~ dbt.type_timestamp() ~ ")"
            ) -%}
        {%- else -%}
            {# For hour/minute/second granularity, cast directly to TIMESTAMP #}
            {%- set start_date = (
                "cast('" ~ start_date ~ "' as " ~ dbt.type_timestamp() ~ ")"
            ) -%}
            {%- set end_date = (
                "cast('" ~ end_date ~ "' as " ~ dbt.type_timestamp() ~ ")"
            ) -%}
        {%- endif -%}

    {%- elif n_dateparts and datepart -%}

        {%- set start_date -%} 
            cast(
            {{ dbt.dateadd(
            datepart, -1 * n_dateparts, dbt_date.today())}} as date)
        {%- endset -%}
        {%- set end_date = dbt_date.tomorrow() -%}
    {%- endif -%}

    {% set intervals = dbt_utils.get_intervals_between(start_date, end_date, datepart) %}

    with
        date_spine as (

            SELECT date_val as date_{{datepart}}

            FROM (

                SELECT {{ dbt.dateadd(datepart, 'row_number() over (order by generated_number) - 1', start_date) }} as date_val

                FROM ({{ dbt_utils.generate_series(intervals) }}) as gs

            ) as sub

            WHERE date_val <= {{ end_date }}

        )
    select
        cast(d.date_{{ datepart }} as {{ dbt.type_timestamp() }}) as date_{{ datepart }}
    from date_spine d
{% endmacro %}
