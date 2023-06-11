# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_package_install = tplroot ~ ".package.install" %}
{%- from tplroot ~ "/map.jinja" import mapdata as wikiless with context %}
{%- from tplroot ~ "/libtofsstack.jinja" import files_switch with context %}

include:
  - {{ sls_package_install }}

Wikiless environment files are managed:
  file.managed:
    - names:
      - {{ wikiless.lookup.paths.config_wikiless }}:
        - source: {{ files_switch(
                        ["wikiless.env", "wikiless.env.j2"],
                        config=wikiless,
                        lookup="wikiless environment file is managed",
                        indent_width=10,
                     )
                  }}
      - {{ wikiless.lookup.paths.config_redis }}:
        - source: {{ files_switch(
                        ["redis.env", "redis.env.j2"],
                        config=wikiless,
                        lookup="redis environment file is managed",
                        indent_width=10,
                     )
                  }}
    - mode: '0640'
    - user: root
    - group: {{ wikiless.lookup.user.name }}
    - makedirs: true
    - template: jinja
    - require:
      - user: {{ wikiless.lookup.user.name }}
    - watch_in:
      - Wikiless is installed
    - context:
        wikiless: {{ wikiless | json }}
