# vi: set ft=yaml.jinja :

{% set url     = 'https://api.github.com/repos/elasticsearch/kibana/tags' %}
{% set version =  salt['cmd.exec_code']('python', 'import json; import urllib; print json.loads(urllib.urlopen("' + url + '").read())[0].get("name")').split('v')[1] %}
{# set version = '3.1.0' #}

include:
  - .depend-nginx
  -  wget

#/usr/share/kibana-{{ version }}:
# archive.extracted:
#   - name:            /usr/share
#   - source:           https://download.elasticsearch.org/kibana/kibana/kibana-{{ version }}.tar.gz
#   - archive_format:   tar
#   - source_hash:      md5=e8e8d4611e223e455bd7c304dbfdb579

/usr/share/kibana-{{ version }}:
  cmd.run:
    - cwd:        /usr/share
    - name:      |-
                 ( wget -O - https://download.elasticsearch.org/kibana/kibana/kibana-{{ version }}.tar.gz \
                 | tar  -zxvf -
                 )
    - unless:      test -d /usr/share/kibana-{{ version }}
    - require:
      - pkg:       wget

/usr/share/kibana:
  file.symlink:
    - target:     /usr/share/kibana-{{ version }}
    - watch:
#     - archive:  /usr/share/kibana-{{ version }}
      - cmd:      /usr/share/kibana-{{ version }}

/usr/share/kibana/app/dashboards/default.json:
  file.managed:
    - source:      salt://{{ sls }}/usr/share/kibana/app/dashboards/default.json
    - user:        root
    - group:       root
    - mode:       '0664'
    - require:
      - file:     /usr/share/kibana
