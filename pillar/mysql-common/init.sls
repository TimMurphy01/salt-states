# vi: set ft=yaml.jinja :

{% if   salt['config.get']('os_family') == 'RedHat' %}

mysql-common:
  pkg:
    name:          mysql-libs

/etc/mysql/my.cnf:
  file:
    name:         /etc/my.cnf

{% elif salt['config.get']('os_family') == 'Debian' %}

mysql-common:
  pkg:
    name:          mysql-common

/etc/mysql/my.cnf:
  file:
    name:         /etc/mysql/my.cnf

{% endif %}
