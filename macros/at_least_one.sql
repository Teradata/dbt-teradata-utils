{# Overriding because the original implementation used 'limit' which is a not a valid Teradata keyword #}

{% macro teradata__test_at_least_one(model, column_name, group_by_columns) %}

{% set pruned_cols = [column_name] %}

{% if group_by_columns|length() > 0 %}

  {% set select_gb_cols = group_by_columns|join(' ,') + ', ' %}
  {% set groupby_gb_cols = 'group by ' + group_by_columns|join(',') %}
  {% set pruned_cols = group_by_columns %}

  {% if column_name not in pruned_cols %}
    {% do pruned_cols.append(column_name) %}
  {% endif %}

{% endif %}

{% set select_pruned_cols = pruned_cols|join(' ,') %}

select *
from (
    with pruned_rows as (
      select
        top 1
        {{ select_pruned_cols }}
      from {{ model }}
      where {{ column_name }} is not null
    )
    select
        {# In TSQL, subquery aggregate columns need aliases #}
        {# thus: a filler col name, 'filler_column' #}
      {{select_gb_cols}}
      count({{ column_name }}) as filler_column

    from pruned_rows

    {{groupby_gb_cols}}

    having count({{ column_name }}) = 0

) validation_errors

{% endmacro %}