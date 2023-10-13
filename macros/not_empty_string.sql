{# Overriding because Teradata treats multiple blanks as an empty string #}

{% macro teradata__test_not_empty_string(model, column_name, trim_whitespace=true) %}

    with

    all_values as (

        select


            {% if trim_whitespace == true -%}

                trim({{ column_name }}) as {{ column_name }}

            {%- else -%}

                {{ column_name }}

            {%- endif %}

        from {{ model }}

    ),

    errors as (

        select * from all_values
        where CONCAT({{ column_name }}, '_')  = '_'

    )

    select * from errors

{% endmacro %}