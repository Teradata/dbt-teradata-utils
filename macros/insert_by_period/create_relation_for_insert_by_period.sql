{% macro create_relation_for_insert_by_period(tmp_identifier, schema, type) -%}
    {% do return (api.Relation.create(identifier=tmp_identifier,
                                               schema=schema, type=type)) %}
{%- endmacro %}