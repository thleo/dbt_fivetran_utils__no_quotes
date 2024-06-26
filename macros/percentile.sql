{% macro percentile(percentile_field, partition_field, percent) -%}

{{ adapter.dispatch('percentile', macro_namespace = fivetran_utils__no_quotes._get_utils_namespaces()) (percentile_field, partition_field, percent) }}

{%- endmacro %}

--percentile calculation specific to Redshift
{% macro default__percentile(percentile_field, partition_field, percent)  %}

    percentile_cont( 
        {{ percent }} )
        within group ( order by {{ percentile_field }} )
        over ( partition by {{ partition_field }} )

{% endmacro %}

--percentile calculation specific to BigQuery
{% macro bigquery__percentile(percentile_field, partition_field, percent)  %}

    percentile_cont( 
        {{ percentile_field }}, 
        {{ percent }}) 
        over (partition by {{ partition_field }}    
        )

{% endmacro %}