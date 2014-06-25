# vi: set ft=yaml.jinja :

{% set psls = sls.split('.')[0] %}

include:
  -  graphite-web
  -  graphite-web.depend-gunicorn
  -  nginx

extend:
  graphite-web:
    pkg:
      - watch_in:
        - service: nginx-common

  /etc/graphite/local_settings.py:
    file:
      - watch_in:
        - service: nginx-common

  python manage.py syncdb --noinput:
    cmd:
      - watch_in:
        - service: nginx-common

/etc/nginx/sites-available/{{ psls }}:
  file.managed:
    - template:    jinja
    - name:     {{ salt['config.get']('/etc/nginx/sites-available:file:name') }}/{{ psls }}{{ salt['config.get']('nginx-common:conf:extension') }}
    - source:      salt://{{ psls }}/etc/nginx/sites-available/{{ psls }}
    - user:        root
    - group:       root
    - mode:       '0644'
    - require:
      - pkg:       nginx
    - watch_in:
      - service:   nginx-common

/etc/nginx/sites-enabled/{{ psls }}:
  file.symlink:
    - target:     /etc/nginx/sites-available/{{ psls }}
    - onlyif:      test -d /etc/nginx/sites-enabled
    - require:
      - pkg:       graphite-web
      - file:     /etc/nginx/sites-available/{{ psls }}
    - watch_in:
      - service:   nginx-common
