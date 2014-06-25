# vi: set ft=yaml.jinja :

{% set minions = salt['roles.list_minions']('etcd') %}
{% set psls    = sls.split('.')[0] %}

include:
  -  salt-master

{% if minions['etcd'] %}

/etc/salt/master.d/etcd.conf:
  file.managed:
    - template:    jinja
    - source:      salt://{{ psls }}/etc/salt/master.d/etcd.conf
    - user:        root
    - group:       root
    - mode:       '0644'
    - require:
      - pkg:       salt-master
    - watch_in:
      - service:   salt-master

{% else %}

/etc/salt/master.d/etcd.conf:
  file.absent:
    - watch_in:
      - service:   salt-master

{% endif %}
