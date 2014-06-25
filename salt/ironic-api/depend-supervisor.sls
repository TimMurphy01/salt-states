# vi: set ft=yaml.jinja :

{% set psls = sls.split('.')[0] %}

{% if salt['config.get']('virtual_subtype') == 'Docker' %}

include:
  -  ironic-api
  -  supervisor

extend:
  ironic-api:
    supervisord.running:
      - require:
        - file:   /var/lock/ironic
        - file:   /var/run/ironic
      - watch:
        - pkg:     ironic-api
        - service: supervisor
        - file:   /etc/ironic/ironic.conf
#       - file:   /etc/ironic/policy.json

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

{% endif %}
