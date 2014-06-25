# vi: set ft=yaml.jinja :

{% set minions = salt['roles.list_minions']('mysql-server') %}
{% set psls    = sls.split('.')[0] %}

include:
  -  python-mysqldb
  -  salt-minion

{% if minions['mysql-server'] %}

/etc/salt/minion.d/mysql-server.conf:
  file.managed:
    - template:    jinja
    - source:      salt://{{ psls }}/etc/salt/minion.d/mysql-server.conf
    - user:        root
    - group:       root
    - mode:       '0644'
    - require:
      - pkg:       python-mysqldb
      - pkg:       salt-minion
    - watch_in:
      - service:   salt-minion

{% endif %}
