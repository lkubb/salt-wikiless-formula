# -*- coding: utf-8 -*-
# vim: ft=yaml
---
wikiless:
  lookup:
    master: template-master
    # Just for testing purposes
    winner: lookup
    added_in_lookup: lookup_value
    compose:
      create_pod: null
      pod_args: null
      project_name: wikiless
      remove_orphans: true
      build: false
      build_args: null
      pull: false
      service:
        container_prefix: null
        ephemeral: true
        pod_prefix: null
        restart_policy: on-failure
        restart_sec: 2
        separator: null
        stop_timeout: null
    paths:
      base: /opt/containers/wikiless
      compose: docker-compose.yml
      config_wikiless: wikiless.env
      config_redis: redis.env
      build: Dockerfile
    user:
      groups: []
      home: null
      name: wikiless
      shell: /usr/sbin/nologin
      uid: null
      gid: null
    containers:
      app:
        image: docker.io/library/node:16-alpine
      redis:
        image: docker.io/library/redis:alpine
    repo: https://codeberg.org/orenom/Wikiless
  install:
    rootless: true
    autoupdate: true
    autoupdate_service: false
    remove_all_data_for_sure: false
  config:
    cache_control: true
    cache_control_interval: 24
    cert_dir: null
    default_lang: en
    domain: localhost
    http_addr: 0.0.0.0
    https_enabled: false
    nonssl_port: 7355
    redirect_http_to_https: false
    redis_password: null
    redis_url: redis://redis:6379
    ssl_port: null
    theme: null
    trust_proxy: false
    trust_proxy_address: 127.0.0.1
    wikimedia_useragent: Wikiless media proxy bot (https://codeberg.org/orenom/Wikiless)
    wikipage_cache_expiration: 3600

  tofs:
    # The files_switch key serves as a selector for alternative
    # directories under the formula files directory. See TOFS pattern
    # doc for more info.
    # Note: Any value not evaluated by `config.get` will be used literally.
    # This can be used to set custom paths, as many levels deep as required.
    files_switch:
      - any/path/can/be/used/here
      - id
      - roles
      - osfinger
      - os
      - os_family
    # All aspects of path/file resolution are customisable using the options below.
    # This is unnecessary in most cases; there are sensible defaults.
    # Default path: salt://< path_prefix >/< dirs.files >/< dirs.default >
    #         I.e.: salt://wikiless/files/default
    # path_prefix: template_alt
    # dirs:
    #   files: files_alt
    #   default: default_alt
    # The entries under `source_files` are prepended to the default source files
    # given for the state
    # source_files:
    #   wikiless-config-file-file-managed:
    #     - 'example_alt.tmpl'
    #     - 'example_alt.tmpl.jinja'

    # For testing purposes
    source_files:
      Wikiless environment file is managed:
      - wikiless.env.j2

  # Just for testing purposes
  winner: pillar
  added_in_pillar: pillar_value
