# vi: set ft=yaml.jinja :

{% if   salt['config.get']('os_family') == 'RedHat' %}

graphite-carbon:
  pkg:
    name:          python-carbon
  user:
    name:          carbon
  group:
    name:          carbon

/var/lib/carbon:
  file:
    name:         /var/lib/carbon

{% elif salt['config.get']('os_family') == 'Debian' %}

graphite-carbon:
  pkg:
    name:          graphite-carbon
  user:
    name:         _graphite
  group:
    name:         _graphite

/var/lib/carbon:
  file:
    name:         /var/lib/graphite

{% endif %}
