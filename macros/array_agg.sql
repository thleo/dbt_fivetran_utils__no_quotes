{% macro array_agg(field_to_agg) -%}

{{ adapter.dispatch('array_agg', macro_namespace = fivetran_utils__no_quotes._get_utils_namespaces()) (field_to_agg) }}

{%- endmacro %}

{% macro default__array_agg(field_to_agg) %}
    array_agg({{ field_to_agg }})
{% endmacro %}

{% macro redshift__array_agg(field_to_agg) %}
    listagg({{ field_to_agg }}, ',')
{% endmacro %}