{# Overridden, because Teradata requires that the result of the subtraction is cast to integer #}

{% macro teradata__get_url_path(field) -%}

    {%- set stripped_url =
        dbt.replace(
            dbt.replace(field, "'http://'", "''"), "'https://'", "''")
    -%}

    {%- set first_slash_pos -%}
        coalesce(
            nullif({{ dbt.position("'/'", stripped_url) }}, 0),
            {{ dbt.position("'?'", stripped_url) }} - 1
            )
    {%- endset -%}

    {%- set parsed_path =
        dbt.split_part(
            dbt.right(
                stripped_url,
                dbt.safe_cast(
                  dbt.length(stripped_url) ~ "-" ~ first_slash_pos,
                  dbt.type_int()
                )
            ),
            "'?'", 1
          )
    -%}

    {{ dbt.safe_cast(
        parsed_path,
        dbt.type_string()
    )}}

{%- endmacro %}