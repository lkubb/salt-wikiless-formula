# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_config_clean = tplroot ~ '.config.clean' %}
{%- from tplroot ~ "/map.jinja" import mapdata as wikiless with context %}

include:
  - {{ sls_config_clean }}

Wikiless is absent:
  compose.removed:
    - name: {{ wikiless.lookup.paths.compose }}
    - volumes: {{ wikiless.install.remove_all_data_for_sure }}
{%- for param in ["project_name", "container_prefix", "pod_prefix", "separator"] %}
{%-   if wikiless.lookup.compose.get(param) is not none %}
    - {{ param }}: {{ wikiless.lookup.compose[param] }}
{%-   endif %}
{%- endfor %}
{%- if wikiless.install.rootless %}
    - user: {{ wikiless.lookup.user.name }}
{%- endif %}
    - require:
      - sls: {{ sls_config_clean }}

Wikiless build/compose files are absent:
  file.absent:
    - names:
      - {{ wikiless.lookup.paths.compose }}
      - {{ wikiless.lookup.paths.build }}
    - require:
      - Wikiless is absent

Wikiless user session is not initialized at boot:
  compose.lingering_managed:
    - name: {{ wikiless.lookup.user.name }}
    - enable: false

Wikiless user account is absent:
  user.absent:
    - name: {{ wikiless.lookup.user.name }}
    - purge: {{ wikiless.install.remove_all_data_for_sure }}
    - require:
      - Wikiless is absent

{%- if wikiless.install.remove_all_data_for_sure %}

Wikiless paths are absent:
  file.absent:
    - names:
      - {{ wikiless.lookup.paths.base }}
    - require:
      - Wikiless is absent
{%- endif %}
