# vi: set ft=yaml.jinja :

iscsitarget:
  pkg.installed:   []
  service.running:
    - enable:      True
    - watch:
      - pkg:       iscsitarget

/etc/default/iscsitarget:
  file.replace:
    - pattern:     ISCSITARGET_ENABLE=false
    - repl:        ISCSITARGET_ENABLE=true
    - watch:
      - pkg:       iscistarget
    - watch_in:
      - service:   iscistarget
