# vi: set ft=yaml.jinja :

{% set environment = salt['grains.get']('environment') %}

include:
  -  orchestrate.salt-minion
  -  orchestrate.graphite-carbon
  -  orchestrate.rabbitmq-server
  -  orchestrate.redis-server

state_sls_sensu-server:
  salt.state:
    - tgt:         roles:sensu-server
    - tgt_type:    grain
    - sls:         sensu-server
    - require:
      - salt:      state_sls_salt-minion
      - salt:      state_sls_graphite-carbon
      - salt:      state_sls_rabbitmq-server
      - salt:      state_sls_redis-server

#-------------------------------------------------------------------------------
# TODO: this will not work until pillar['roles'] can be passed
#-------------------------------------------------------------------------------

#state_sls_orchestrate_sensu-server:
# salt.state:
#   - tgt:        'G:environment:{{ environment }} and not G@roles:sensu-server'
#   - tgt_type:    compound
#   - sls:         orchestrate
#   - require:
#     - salt:      state_sls_sensu-server
