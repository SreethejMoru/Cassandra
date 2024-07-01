# /srv/salt/top.sls

base:
  '*':
    - corretto.install
    - cassandra.keyring
    - cassandra.sources_list
    - cassandra.install
    - cassandra.config
    - cassandra.cassandra_rackdc
    - cassandra.swap