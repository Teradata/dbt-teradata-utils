{# This macro had to be overriden because Teradata has its own metadata catalog. #}

{% macro default__get_tables_by_pattern_sql(schema_pattern, table_pattern, exclude='', database=target.database) %}

        select distinct
            DatabaseName as "table_schema",
            TableName as "table_name",
            case
              when TableKind = 'T' then 'table'
              when TableKind = 'V' then 'view'
              else TableKind
            end as table_type
        from dbc.tablesV
        where DatabaseName like '{{ schema_pattern }}' (NOT CASESPECIFIC)
        and TableName like '{{ table_pattern }}' (NOT CASESPECIFIC)
        and TableName not like '{{ exclude }}' (NOT CASESPECIFIC)

{% endmacro %}
