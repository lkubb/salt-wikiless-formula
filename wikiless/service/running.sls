# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_config_file = tplroot ~ ".config.file" %}
{%- from tplroot ~ "/map.jinja" import mapdata as wikiless with context %}

include:
  - {{ sls_config_file }}

Wikiless service is enabled:
  compose.enabled:
    - name: {{ wikiless.lookup.paths.compose }}
{%- for param in ["project_name", "container_prefix", "pod_prefix", "separator"] %}
{%-   if wikiless.lookup.compose.get(param) is not none %}
    - {{ param }}: {{ wikiless.lookup.compose[param] }}
{%-   endif %}
{%- endfor %}
    - require:
      - Wikiless is installed
{%- if wikiless.install.rootless %}
    - user: {{ wikiless.lookup.user.name }}
{%- endif %}

Wikiless service is running:
  compose.running:
    - name: {{ wikiless.lookup.paths.compose }}
{%- for param in ["project_name", "container_prefix", "pod_prefix", "separator"] %}
{%-   if wikiless.lookup.compose.get(param) is not none %}
    - {{ param }}: {{ wikiless.lookup.compose[param] }}
{%-   endif %}
{%- endfor %}
{%- if wikiless.install.rootless %}
    - user: {{ wikiless.lookup.user.name }}
{%- endif %}
    - watch:
      - Wikiless is installed
