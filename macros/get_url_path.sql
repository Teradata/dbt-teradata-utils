{# Overridden, because Teradata requires that the result of the subtraction is cast to integer #}
{# make it more conformant with Python urllib.parse #}
{% macro teradata__get_url_path(field) -%}

    {%- set stripped_url =
        dbt.replace(
            dbt.replace(field, "'http://'", "''"), "'https://'", "''")
    -%}

    {%- set stripped_url_with_slash -%}
         nvl2(nullif({{ dbt.position("'/'", stripped_url) }}, 0), {{ stripped_url }}, NULL)
    {%- endset -%}

    {%- set first_slash_pos -%}
        {{ dbt.position("'/'", stripped_url_with_slash) }}
    {%- endset -%}

    {%- set parsed_path =
        dbt.split_part(
            dbt.split_part(
                dbt.right(
                    stripped_url_with_slash,
                    dbt.safe_cast(
                      dbt.length(stripped_url_with_slash) ~ "-" ~ first_slash_pos ~ "+ 1",
                      dbt.type_int()
                    )
                ),
                "'?'", 1
              ),
              "'#'", 1
          )
    -%}

    {{ dbt.safe_cast(
        parsed_path,
        dbt.type_string()
    )}}

{%- endmacro %}