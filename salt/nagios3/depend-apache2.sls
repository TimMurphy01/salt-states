# vi: set ft=yaml.jinja :

{% set psls = sls.split('.')[0] %}

include:
  -  apache2
  -  nagios3.libapache2-mod-php5

/etc/apache2/sites-available/{{ psls }}.conf:
  file.managed:
    - template:    jinja
    - name:     {{ salt['config.get']('/etc/apache2/sites-available:file:name') }}/{{ psls }}{{ salt['config.get']('apache2:conf:extension') }}
    - source:      salt://{{ psls }}/etc/apache2/conf.d/{{ psls }}.conf
    - user:        root
    - group:       root
    - mode:       '0644'
    - require:
      - pkg:       apache2
    - watch_in:
      - service:   apache2

/etc/apache2/sites-enabled/{{ psls }}:
  file.symlink:
    - target:     /etc/apache2/sites-available/{{ psls }}
    - onlyif:      test -d /etc/apache2/sites-enabled
    - require:
      - file:     /etc/apache2/sites-available/{{ psls }}
