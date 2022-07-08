# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_service_clean = tplroot ~ '.service.clean' %}
{%- from tplroot ~ "/map.jinja" import mapdata as wikiless with context %}

include:
  - {{ sls_service_clean }}

# This does not lead to the containers/services being rebuilt
# and thus differs from the usual behavior
Wikiless environment files are absent:
  file.absent:
    - names:
      - {{ wikiless.lookup.paths.config_wikiless }}
      - {{ wikiless.lookup.paths.config_redis }}
    - require:
      - sls: {{ sls_service_clean }}
