# vi: set ft=yaml.jinja :

include:
  -  java-common
  -  python-apt

{% if salt['config.get']('os_family') == 'Debian' %}

accepted-oracle-license-v1-1-select:
  cmd.run:
    - name:      |-
                 ( ( echo -n "debconf shared/accepted-oracle-license-v1-1"
                     echo    " select true"
                   )                                                           \
                 | debconf-set-selections
                 )
    - unless:    |-
                 ( debconf-get-selections                                      \
                 | egrep "debconf\s+shared/accepted-oracle-license-v1-1.*true"
                 )

accepted-oracle-license-v1-1-seen:
  cmd.wait:
    - name:      |-
                 ( ( echo -n "debconf shared/accepted-oracle-license-v1-1"
                     echo      " seen true"
                   )                                                           \
                 | debconf-set-selections
                 )
    - watch:
      - cmd:       accepted-oracle-license-v1-1-select
    - require_in:
      - pkg:       oracle-java7-installer

webupd8team-java:
  pkgrepo.managed:
    - name:        deb http://ppa.launchpad.net/webupd8team/java/ubuntu {{ salt['config.get']('oscodename') }} main
    - file:       /etc/apt/sources.list.d/webupd8team-java.list
    - keyid:       EEA14886
    - keyserver:   keyserver.ubuntu.com
    - require:
      - pkg:       python-apt
    - require_in:
      - pkg:       oracle-java7-installer

{% endif %}

oracle-java7-installer:
  pkg:
    - installed
    - name:     {{ salt['config.get']('oracle-java7-installer:pkg:name') }}
