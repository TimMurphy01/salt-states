# vi: set ft=yaml.jinja :

{% set minions = salt['roles.list_minions']('graphite-carbon') %}
{% set psls    = sls.split('.')[0] %}

include:
  -  salt-minion

{% if minions['graphite-carbon'] %}

/etc/salt/minion.d/graphite-carbon.conf:
  file.managed:
    - template:    jinja
    - source:      salt://{{ psls }}/etc/salt/minion.d/graphite-carbon.conf
    - user:        root
    - group:       root
    - mode:       '0644'
    - require:
      - pkg:       salt-minion
    - watch_in:
      - service:   salt-minion

{% endif %}
