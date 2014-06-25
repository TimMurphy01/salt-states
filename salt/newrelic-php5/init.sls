# vi: set ft=yaml.jinja :

include:
  -  newrelic
  -  php5-cli

newrelic-php5:
  pkg.installed:
    - order:      -1
    - require:
      - pkgrepo:   newrelic

newrelic-install install:
  cmd.wait:
    - env:
      - NR_INSTALL_KEY:   {{ salt['config.get']('newrelic:license_key') }}
      - NR_INSTALL_SILENT:  '1'
    - watch:
      - pkg:       newrelic-php5

/usr/lib/newrelic-php5/scripts/newrelic.ini:
  file.managed:
    - template:    jinja
    - source:      salt://{{ sls }}/usr/lib/newrelic-php5/scripts/newrelic.ini
    - user:        root
    - group:       root
    - mode:       '0644'
    - defaults:
        appname:   PHP Application
