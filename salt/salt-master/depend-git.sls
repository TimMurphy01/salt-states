# vi: set ft=yaml.jinja :

{% set psls = sls.split('.')[0] %}

include:
  -  git
  -  openssh-client
  -  openssh-client.known_hosts.github.com
  -  python-pygit2

/etc/salt/master.d/fileserver_backend.conf:
  file.managed:
    - template:    jinja
    - source:      salt://{{ psls }}/etc/salt/master.d/fileserver_backend.conf
    - user:        root
    - group:       root
    - mode:       '0644'
    - require:
      - pkg:       salt-master
      - pip:       python-pygit2
    - watch_in:
      - service:   salt-master
