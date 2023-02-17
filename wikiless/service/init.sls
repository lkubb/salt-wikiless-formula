# vim: ft=sls

{#-
    Starts the wikiless, redis container services
    and enables them at boot time.
    Has a dependency on `wikiless.config`_.
#}

include:
  - .running
