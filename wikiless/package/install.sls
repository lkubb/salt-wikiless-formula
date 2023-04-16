# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as wikiless with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

Wikiless user account is present:
  user.present:
{%- for param, val in wikiless.lookup.user.items() %}
{%-   if val is not none and param != "groups" %}
    - {{ param }}: {{ val }}
{%-   endif %}
{%- endfor %}
    - usergroup: true
    - createhome: true
    - groups: {{ wikiless.lookup.user.groups | json }}
    # (on Debian 11) subuid/subgid are only added automatically for non-system users
    - system: false

Wikiless user session is initialized at boot:
  compose.lingering_managed:
    - name: {{ wikiless.lookup.user.name }}
    - enable: {{ wikiless.install.rootless }}
    - require:
      - user: {{ wikiless.lookup.user.name }}

Wikiless paths are present:
  file.directory:
    - names:
      - {{ wikiless.lookup.paths.base }}
    - user: {{ wikiless.lookup.user.name }}
    - group: {{ wikiless.lookup.user.name }}
    - makedirs: true
    - require:
      - user: {{ wikiless.lookup.user.name }}

{%- if wikiless.install.podman_api %}

Wikiless podman API is enabled:
  compose.systemd_service_enabled:
    - name: podman.socket
    - user: {{ wikiless.lookup.user.name }}
    - require:
      - Wikiless user session is initialized at boot

Wikiless podman API is available:
  compose.systemd_service_running:
    - name: podman.socket
    - user: {{ wikiless.lookup.user.name }}
    - require:
      - Wikiless user session is initialized at boot
{%- endif %}

Wikiless build/compose files are managed:
  file.managed:
    - names:
      - {{ wikiless.lookup.paths.build }}:
        - source: {{ files_switch(["Dockerfile", "Dockerfile.j2"],
                                  lookup="Wikiless build file is present",
                                  indent_width=10,
                     )
                  }}
      - {{ wikiless.lookup.paths.compose }}:
        - source: {{ files_switch(["docker-compose.yml", "docker-compose.yml.j2"],
                                  lookup="Wikiless compose file is present",
                                  indent_width=10,
                     )
                  }}
    - mode: '0644'
    - user: root
    - group: {{ wikiless.lookup.rootgroup }}
    - makedirs: True
    - template: jinja
    - makedirs: true
    - context:
        wikiless: {{ wikiless | json }}

Wikiless is installed:
  compose.installed:
    - name: {{ wikiless.lookup.paths.compose }}
{%- for param, val in wikiless.lookup.compose.items() %}
{%-   if val is not none and param != "service" %}
    - {{ param }}: {{ val }}
{%-   endif %}
{%- endfor %}
{%- for param, val in wikiless.lookup.compose.service.items() %}
{%-   if val is not none %}
    - {{ param }}: {{ val }}
{%-   endif %}
{%- endfor %}
    - watch:
      - file: {{ wikiless.lookup.paths.compose }}
      - file: {{ wikiless.lookup.paths.build }}
{%- if wikiless.install.rootless %}
    - user: {{ wikiless.lookup.user.name }}
    - require:
      - user: {{ wikiless.lookup.user.name }}
{%- endif %}

{%- if wikiless.install.autoupdate_service is not none %}

Podman autoupdate service is managed for Wikiless:
{%-   if wikiless.install.rootless %}
  compose.systemd_service_{{ "enabled" if wikiless.install.autoupdate_service else "disabled" }}:
    - user: {{ wikiless.lookup.user.name }}
{%-   else %}
  service.{{ "enabled" if wikiless.install.autoupdate_service else "disabled" }}:
{%-   endif %}
    - name: podman-auto-update.timer
{%- endif %}
