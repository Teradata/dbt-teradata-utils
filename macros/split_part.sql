{# The default implementation does not quote function parameters #}
{# Also, the function used in the original macro ('split_part') is called 'strtok' in Teradata #}

{% macro default__split_part(string_text, delimiter_text, part_number) %}

    strtok(
        '{{ string_text }}',
        '{{ delimiter_text }}',
        {{ part_number }}
        )

{% endmacro %}
