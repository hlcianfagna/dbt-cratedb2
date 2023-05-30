{% macro postgres__create_schema(relation) -%}
  {%- call statement('create_schema') -%}
    /* schemas are not created in CrateDB */
    DROP TABLE IF EXISTS thisschemadefinitelydoesnotexits.thiswouldnotexist
    /* but we need to run something to not have just EOF */
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
    drop {{ relation.type }} if exists "{{ relation.schema }}"."{{ relation.identifier }}"
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
  create view "{{ relation.schema }}"."{{ relation.identifier }}" as 
    {{ sql|replace('"crate".', "") }}
  ;
{%- endmacro %}

{% macro postgres__rename_relation(from_relation, to_relation) -%}
  {% do drop_relation(to_relation) %}
  {% set relation_type = run_query("select table_type from information_schema.tables where table_schema = '{{ from_relation.schema }}' and table_name = '{{ from_relation.identifier }}'") %}
  {% if relation_type == 'VIEW' %}    
    {% set view_definition = run_query("SELECT view_definition FROM information_schema.views WHERE table_schema = '{{ from_relation.schema }}' AND table_name = '{{ from_relation.identifier }}'") %}
	{% call statement('drop_view') -%}
      DROP VIEW IF EXISTS {{ to_relation.schema }}.{{ to_relation.identifier }};
    {%- endcall %}
    {% call statement('create_view') -%}
      CREATE VIEW {{ to_relation.schema }}.{{ to_relation.identifier }} AS {{ view_definition }}
    {%- endcall %}
  {% else %}
    {% call statement('rename_table') -%}
      ALTER TABLE {{ from_relation.schema }}.{{ from_relation.identifier }}
      RENAME TO {{ to_relation.schema }}.{{ to_relation.identifier }}
    {%- endcall %}
  {% endif %}
{% endmacro %}
