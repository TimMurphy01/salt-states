# vi: set ft=yaml.jinja :

{% set psls = sls.split('.')[0] %}

{% if salt['config.get']('virtual_subtype') == 'Docker' %}

include:
  -  neutron-server
  -  supervisor

extend:
  neutron-server:
    supervisord.running:
      - require:
        - file:   /var/run/neutron
      - watch:
        - pkg:     neutron-server
        - service: supervisor
#       - file:   /etc/neutron/api-paste.ini
        - file:   /etc/neutron/fwaas_driver.ini
        - file:   /etc/neutron/l3_agent.ini
        - file:   /etc/neutron/neutron.conf
#       - file:   /etc/neutron/policy.json
        - file:   /etc/neutron/vpn_agent.ini
#       - file:   /etc/default/neutron-server

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
