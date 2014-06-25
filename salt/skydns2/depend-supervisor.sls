# vi: set ft=yaml.jinja :

{% set minions = salt['roles.list_minions']('etcd') %}
{% set psls    = sls.split('.')[0] %}

include:
  -  skydns2
  -  supervisor
  {% if minions['etcd'] %}
  -  skydns2.relate-etcd
  {% endif %}

skydns2:
  supervisord.running:
    - unless:    |-
                 ( echo  "${bootstrap}"                                        \
                 | grep -q "true"
                 )
    - watch:
      - service:   supervisor
      - cmd:       go install -v . ./...
     {% if minions['etcd'] %}
      - file:     /etc/profile.d/skydns2.sh
      - module:    etcdctl set /skydns/config
     {% endif %}

/etc/supervisor/conf.d/{{ psls }}.conf:
  file.managed:
    - template:    jinja
    - source:      salt://{{ psls }}/etc/supervisor/conf.d/{{ psls }}.conf
    - user:        root
    - group:       root
    - mode:       '0644'
    - require:
      - pkg:       supervisor
    - watch_in:
      - service:   supervisor
