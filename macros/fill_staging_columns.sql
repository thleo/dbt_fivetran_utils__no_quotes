{% macro fill_staging_columns(source_columns, staging_columns) -%}

{%- set source_column_names = source_columns|map(attribute='name')|map('lower')|list -%}

{%- for column in staging_columns %}
    {% if column.name|lower in source_column_names -%}
        {{ fivetran_utils__no_quotes.quote_column(column) }} as 
        {%- if 'alias' in column %} {{ column.alias }} {% else %} {{ fivetran_utils__no_quotes.quote_column(column) }} {%- endif -%}
    {%- else -%}
        cast(null as {{ column.datatype }})
        {%- if 'alias' in column %} as {{ column.alias }} {% else %} as {{ fivetran_utils__no_quotes.quote_column(column) }} {% endif -%}
    {%- endif -%}
    {%- if not loop.last -%} , {% endif -%}
{% endfor %}

{% endmacro %}


{% macro quote_column(column) %}
    {% if 'quote' in column %}
        {% if column.quote %}
            {% if target.type in ('bigquery', 'spark') %}
            `{{ column.name }}`
            {% elif target.type == 'snowflake' %}
            {{ column.name | upper }} -- this is where code differs from the offical repo for fivetran_utils__no_quotes
            {% else %}
            "{{ column.name }}"
            {% endif %}
        {% else %}
        {{ column.name }}
        {% endif %}
    {% else %}
    {{ column.name }}
    {% endif %}
{% endmacro %}