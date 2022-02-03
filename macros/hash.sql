
{# The original implementation used 'md5' function which is not available in Teradata #}
{# This implementation requires that a custom UDF is installed in 'GLOBAL_FUNCTIONS' database #}
{# See README for details. #}

{% macro teradata__hash(field) -%}
    GLOBAL_FUNCTIONS.hash_md5(cast({{field}} as {{dbt_utils.type_string()}}))
{%- endmacro %}
