# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as wikiless with context %}

wikiless service is dead:
  compose.dead:
    - name: {{ wikiless.lookup.paths.compose }}
{%- for param in ["project_name", "container_prefix", "pod_prefix", "separator"] %}
{%-   if wikiless.lookup.compose.get(param) is not none %}
    - {{ param }}: {{ wikiless.lookup.compose[param] }}
{%-   endif %}
{%- endfor %}
{%- if wikiless.install.rootless %}
    - user: {{ wikiless.lookup.user.name }}
{%- endif %}

wikiless service is disabled:
  compose.disabled:
    - name: {{ wikiless.lookup.paths.compose }}
{%- for param in ["project_name", "container_prefix", "pod_prefix", "separator"] %}
{%-   if wikiless.lookup.compose.get(param) is not none %}
    - {{ param }}: {{ wikiless.lookup.compose[param] }}
{%-   endif %}
{%- endfor %}
{%- if wikiless.install.rootless %}
    - user: {{ wikiless.lookup.user.name }}
{%- endif %}
