{# This macro had to be overriden because Teradata has its own metadata catalog. #}

{% macro teradata__get_tables_by_pattern_sql(schema_pattern, table_pattern, exclude='', database=target.database) %}

        SELECT DISTINCT
            DatabaseName AS "table_schema",
            TableName AS "table_name",
            CASE
              WHEN TableKind = 'T' THEN 'table'
              WHEN TableKind = 'V' THEN 'view'
              WHEN TableKind = 'O' THEN 'table'
              ELSE TableKind
            END AS table_type
        FROM dbc.tablesV
        WHERE DatabaseName LIKE '{{ schema_pattern }}' (NOT CASESPECIFIC)
        AND TableName LIKE '{{ table_pattern }}' (NOT CASESPECIFIC)
        AND TableName NOT LIKE '{{ exclude }}' (NOT CASESPECIFIC)

{% endmacro %}
