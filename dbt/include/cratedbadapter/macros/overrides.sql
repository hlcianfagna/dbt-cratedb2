{% macro postgres__create_schema(relation) -%}
  {%- call statement('create_schema') -%}
    /* schemas are not created in CrateDB */
  {% endcall %}
{% endmacro %}

{% macro postgres__create_table_as(temporary, relation, sql) -%}
  {%- set unlogged = config.get('unlogged', default=false) -%}
  {%- set sql_header = config.get('sql_header', none) -%}

  {{ sql_header if sql_header is not none }}

  create  table {{ relation }}
  as (
    {{ sql|replace('"crate".', "") }}
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
    drop {{ relation.type }} if exists {{ relation|replace('"crate".', "") }} 
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
    {{ sql|replace('"crate".', "") }}
  ;
{%- endmacro %}

{% macro postgres__rename_relation(from_relation, to_relation) -%}
  {% call statement('rename_relation') -%}
        create or replace view {{ to_relation.name|replace('"crate".', "") }} as 
        select * from {{ from_relation|replace('"crate".', "") }}
  {%- endcall %}
{% endmacro %}
