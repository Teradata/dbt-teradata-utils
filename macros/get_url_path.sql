{# Overridden, because Teradata requires that the result of the subtraction is cast to integer #}

{% macro default__get_url_path(field) -%}

    {%- set stripped_url =
        dbt_utils.replace(
            dbt_utils.replace(field, "'http://'", "''"), "'https://'", "''")
    -%}

    {%- set first_slash_pos -%}
        coalesce(
            nullif({{dbt_utils.position("'/'", stripped_url)}}, 0),
            {{dbt_utils.position("'?'", stripped_url)}} - 1
            )
    {%- endset -%}

    {%- set parsed_path =
        dbt_utils.split_part(
            dbt_utils.right(
                stripped_url,
                dbt_utils.safe_cast(
                  dbt_utils.length(stripped_url) ~ "-" ~ first_slash_pos,
                  dbt_utils.type_int()
                )
            ),
            "'?'", 1
          )
    -%}

    {{ dbt_utils.safe_cast(
        parsed_path,
        dbt_utils.type_string()
    )}}

{%- endmacro %}
