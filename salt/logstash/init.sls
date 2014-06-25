# vi: set ft=yaml.jinja :

{% set version = '1.4' %}

include:
  -  libzmq3-dev
  -  oracle-java7-installer
  -  python-apt

logstash:
  pkgrepo.managed:
    - name:     {{ salt['config.get']('logstash:pkgrepo:name') }}
    - file:     {{ salt['config.get']('logstash:pkgrepo:file') }}
    - gpgkey:      http://packages.elasticsearch.org/GPG-KEY-elasticsearch
    - key_url:     http://packages.elasticsearch.org/GPG-KEY-elasticsearch
    - humanname:   logstash repository for {{ version }}.x packages
    - baseurl:     http://packages.elasticsearch.org/logstash/{{ version }}/centos
    - enabled:     1
    - gpgcheck:    1
    - consolidate: True
   {% if salt['config.get']('os_family') == 'Debian' %}
    - require:
      - pkg:       python-apt
   {% endif %}
  pkg.installed:
    - order:      -1
    - require:
      - pkgrepo:   logstash
  service.running:
    - order:      -1
    - enable:      True
    - require:
      - pkg:       oracle-java7-installer
    - watch:
      - pkg:       logstash

/etc/default/logstash:
  file.replace:
    - name:     {{ salt['config.get']('/etc/default/logstash:file:name') }}
   {% if   salt['config.get']('os_family') == 'RedHat' %}
    - pattern:     START=false
    - repl:        START=true
   {% elif salt['config.get']('os_family') == 'Debian' %}
    - pattern:     START=no
    - repl:        START=yes
   {% endif %}
    - watch:
      - pkg:       logstash
    - watch_in:
      - service:   logstash

{% if 'logstash' in salt['config.get']('roles', []) %}

/etc/logstash/conf.d/input-zeromq.conf:
  file.managed:
    - source:      salt://{{ sls }}/etc/logstash/conf.d/input-zeromq.conf
    - user:        logstash
    - group:       logstash
    - mode:       '0644'
    - require:
      - pkg:       libzmq3-dev
      - pkg:       logstash
    - watch_in:
      - service:   logstash

/etc/logstash/conf.d/output-zeromq.conf:
  file.absent:
    - watch_in:
      - service:   logstash

{% else %}

/etc/logstash/conf.d/input-zeromq.conf:
  file.absent:
    - watch_in:
      - service:   logstash

/etc/logstash/conf.d/output-zeromq.conf:
  file.managed:
    - template:    jinja
    - source:      salt://{{ sls }}/etc/logstash/conf.d/output-zeromq.conf
    - user:        logstash
    - group:       logstash
    - mode:       '0644'
    - require:
      - pkg:       libzmq3-dev
      - pkg:       logstash
    - watch_in:
      - service:   logstash

{% endif %}
