{# Overriding because the original implementation used 'SELECT *,..'. Teradata allows '*' with other columns in a select statement #}
{# only when '*' is qualified with a table/view name #}

{% macro teradata__test_fewer_rows_than(model, compare_model) %}

{{ config(fail_calc = 'coalesce(row_count_delta, 0)') }}

WITH a AS (

    SELECT count(*) AS count_our_model FROM {{ model }}

),
b AS (

    SELECT count(*) AS count_comparison_model FROM {{ compare_model }}

),
counts AS (

    SELECT
        count_our_model,
        count_comparison_model
    FROM a
    CROSS JOIN b

),
final AS (

    SELECT counts.*,
        CASE
            -- fail the test if we have more rows than the reference model and return the row count delta
            WHEN count_our_model > count_comparison_model THEN (count_our_model - count_comparison_model)
            -- fail the test if they are the same number
            WHEN count_our_model = count_comparison_model THEN 1
            -- pass the test if the delta is positive (i.e. return the number 0)
            ELSE 0
    END AS row_count_delta
    FROM counts

)

SELECT * FROM final

{% endmacro %}
