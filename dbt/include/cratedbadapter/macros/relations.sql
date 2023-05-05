{% macro postgres_get_relations () -%}
  {%- call statement('relations', fetch_result=True) -%}
    select 'mock' as referenced_schema,'referenced ' as referenced_name,
        'mock' as dependent_schema,'dependent' as dependent_name;
  {%- endcall -%}
  {{ return(load_result('relations').table) }}
{% endmacro %}
