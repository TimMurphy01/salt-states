# vi: set ft=yaml.jinja :

{% set psls = sls.split('.')[0] %}

{% if salt['config.get']('virtual_subtype') == 'Docker' %}

include:
  -  ceilometer-collector
  -  supervisor

extend:
  ceilometer-collector:
    supervisord.running:
      - require:
        - file:   /var/lock/ceilometer
        - file:   /var/run/ceilometer
      - watch:
        - pkg:     ceilometer-collector
        - service: supervisor
        - file:   /etc/ceilometer/ceilometer.conf
#       - file:   /etc/ceilometer/pipeline.yaml
#       - file:   /etc/ceilometer/policy.json
#       - file:   /etc/ceilometer/sources.json

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
