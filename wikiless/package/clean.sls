# vim: ft=sls

{#-
    Removes the wikiless, redis containers
    and the corresponding user account and service units.
    Has a depency on `wikiless.config.clean`_.
    If ``remove_all_data_for_sure`` was set, also removes all data.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_config_clean = tplroot ~ ".config.clean" %}
{%- from tplroot ~ "/map.jinja" import mapdata as wikiless with context %}

include:
  - {{ sls_config_clean }}

{%- if wikiless.install.autoupdate_service %}

Podman autoupdate service is disabled for Wikiless:
{%-   if wikiless.install.rootless %}
  compose.systemd_service_disabled:
    - user: {{ wikiless.lookup.user.name }}
{%-   else %}
  service.disabled:
{%-   endif %}
    - name: podman-auto-update.timer
{%- endif %}

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

{%- if wikiless.install.podman_api %}

Wikiless podman API is unavailable:
  compose.systemd_service_dead:
    - name: podman
    - user: {{ wikiless.lookup.user.name }}
    - onlyif:
      - fun: user.info
        name: {{ wikiless.lookup.user.name }}

Wikiless podman API is disabled:
  compose.systemd_service_disabled:
    - name: podman
    - user: {{ wikiless.lookup.user.name }}
    - onlyif:
      - fun: user.info
        name: {{ wikiless.lookup.user.name }}
{%- endif %}

Wikiless user session is not initialized at boot:
  compose.lingering_managed:
    - name: {{ wikiless.lookup.user.name }}
    - enable: false
    - onlyif:
      - fun: user.info
        name: {{ wikiless.lookup.user.name }}

Wikiless user account is absent:
  user.absent:
    - name: {{ wikiless.lookup.user.name }}
    - purge: {{ wikiless.install.remove_all_data_for_sure }}
    - require:
      - Wikiless is absent
    - retry:
        attempts: 5
        interval: 2

{%- if wikiless.install.remove_all_data_for_sure %}

Wikiless paths are absent:
  file.absent:
    - names:
      - {{ wikiless.lookup.paths.base }}
    - require:
      - Wikiless is absent
{%- endif %}
