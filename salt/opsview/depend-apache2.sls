# vi: set ft=yaml.jinja :

{% set psls = sls.split('.')[0] %}

include:
  -  apache2
  -  opsview

/etc/apache2/sites-available/{{ psls }}:
  file.managed:
    - template:    jinja
    - name:     {{ salt['config.get']('/etc/apache2/sites-available:file:name') }}/{{ psls }}{{ salt['config.get']('apache2:conf:extension') }}
    - source:      salt://{{ psls }}/etc/apache2/sites-available/{{ psls }}
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

usermod -G nagcmd {{ salt['config.get']('apache2:user:name') }}:
  cmd.run:
    - unless:    |-
                 ( id    -Gn {{ salt['config.get']('apache2:user:name') }}     \
                 | egrep -q nagcmd
                 )
    - require:
      - pkg:       apache2
      - pkg:       opsview
    - watch_in:
      - service:   apache2
