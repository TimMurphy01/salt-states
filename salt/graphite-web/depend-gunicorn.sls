# vi: set ft=yaml.jinja :

{% set psls = sls.split('.')[0] %}

include:
  -  graphite-web
  -  gunicorn
  -  python-psutil
  {% if salt['config.get']('os_family') == 'RedHat' %}
  -  supervisor
  {% endif %}

extend:
  graphite-web:
    pkg:
      - watch_in:
       {% if   salt['config.get']('os_family') == 'RedHat' %}
        - service: supervisor
       {% elif salt['config.get']('os_family') == 'Debian' %}
        - service: gunicorn
       {% endif %}

  /var/run/gunicorn:
    file:
      - group:  {{ salt['config.get']('graphite-web:group:name') }}
      - watch:
        - pkg:     graphite-web

/etc/gunicorn.d/{{ psls }}:
  file.managed:
    - template:    jinja
    - source:      salt://{{ psls }}/etc/gunicorn.d/{{ psls }}
    - user:        root
    - group:       root
    - mode:       '0644'
    - require:
      - pkg:       gunicorn
      - pkg:       python-psutil
    - watch_in:
     {% if   salt['config.get']('os_family') == 'RedHat' %}
      - service:   supervisor
     {% elif salt['config.get']('os_family') == 'Debian' %}
      - service:   gunicorn
     {% endif %}

{% if salt['config.get']('os_family') == 'RedHat' %}

/etc/supervisor/conf.d/{{ psls }}.conf:
  file.managed:
    - template:    jinja
    - source:      salt://{{ psls }}/etc/supervisor/conf.d/{{ psls }}.conf
    - require:
      - pkg:       graphite-web
      - pkg:       gunicorn
      - pkg:       supervisor
      - file:     /var/log/gunicorn
      - file:     /var/run/gunicorn
    - watch_in:
      - service:   supervisor

{% endif %}
