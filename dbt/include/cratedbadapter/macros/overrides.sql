{% macro postgres__create_table_as(temporary, relation, sql) -%}
  {%- set unlogged = config.get('unlogged', default=false) -%}
  {%- set sql_header = config.get('sql_header', none) -%}

  {{ sql_header if sql_header is not none }}

  create  table {{ relation }}
  as (
    {{ sql }}
  );
{%- endmacro %}

{% macro postgres__drop_schema(relation) -%}
  {% if relation.database -%}
    {{ adapter.verify_database(relation.database) }}
  {%- endif -%}
  {%- call statement('drop_schema') -%}
    /* schemas are not dropped in CrateDB */
  {%- endcall -%}
{% endmacro %}

{% macro default__drop_relation(relation) -%}
  {% call statement('drop_relation', auto_begin=False) -%}
    drop {{ relation.type }} if exists {{ relation }} 
  {%- endcall %}
{% endmacro %}

{% macro default__drop_schema(relation) -%}
  {%- call statement('drop_schema') -%}
    /* schemas are not dropped in CrateDB */
  {% endcall %}
{% endmacro %}

{% macro default__create_view_as(relation, sql) -%}
  {%- set sql_header = config.get('sql_header', none) -%}

  {{ sql_header if sql_header is not none }}
  create view {{ relation }} as 
    {{ sql }}
  ;
{%- endmacro %}
