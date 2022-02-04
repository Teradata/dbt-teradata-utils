{# Overriding because the original implementation used 'as threshold' but 'threshold' is a reserved word in Teradata #}
{% macro teradata__test_recency(model, field, datepart, interval) %}

{% set threshold = dbt_utils.dateadd(datepart, interval * -1, dbt_utils.current_timestamp()) %}

WITH recency AS (

    SELECT max({{field}}) AS most_recent
    FROM {{ model }}

)

SELECT
    most_recent,
    {{ threshold }} AS _threshold

FROM recency
WHERE most_recent < {{ threshold }}

{% endmacro %}
