{% macro fill_parkings(column_name) %}
    CASE
        WHEN {{ column_name }} = 'Sin especificar'  THEN '0'
        ELSE {{ column_name }} 
    END
{% endmacro %}

{% macro fill_with_zeros(property_type,column_name) %}
    {% set properties=['casa','apartamento','apartaestudio'] %}
    CASE
        WHEN {{ column_name }} = 'Sin especificar' and {{ property_type }} in ({% for property in properties -%} "{{property}}"{{',' if not loop.last else ''}} {%- endfor %}) THEN '1'
        WHEN {{ column_name }} = 'Sin especificar' THEN '0'
        ELSE {{ column_name }}
    END
{% endmacro %}

{% macro fill_stratum(column_name_one,column_name_two) %}
    CASE
        WHEN {{ column_name_two }} IS NULL AND {{ column_name_one }} in ('especificar','0') THEN '3'
        WHEN {{ column_name_two }} IS NULL THEN {{ column_name_one }}
        WHEN {{ column_name_two }} IS NOT NULL THEN {{ column_name_two }} 
    END
{% endmacro %}

