{% macro incremental_filter(table_names, include_where) -%}


    {% if is_incremental() %}
   {% if include_where == true %}where{% endif %}

    (
       {% for t in table_names %}
            lower({{t}}.sys_period) > (select max(updated_ts) from {{ this }})
            {% if not loop.last %}or{% endif %}
        {% endfor %}
    )
    {% endif %}

{%- endmacro %}
