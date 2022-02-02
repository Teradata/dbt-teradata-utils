{# Overriding because the original implementation used 'as threshold' but 'threshold' is a reserved word in Teradata #}
{% macro teradata__test_recency(model, field, datepart, interval) %}

{% set threshold = dbt_utils.dateadd(datepart, interval * -1, dbt_utils.current_timestamp()) %}

with recency as (

    select max({{field}}) as most_recent
    from {{ model }}

)

select

    most_recent,
    {{ threshold }} as _threshold

from recency
where most_recent < {{ threshold }}

{% endmacro %}
