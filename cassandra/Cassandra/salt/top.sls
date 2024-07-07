# /srv/salt/top.sls

base:
  '*':
    - corretto.install
    - cassandra.keyring
    - cassandra.sources_list
    - cassandra.install
    - cassandra.cassandra
    - cassandra.cassandra_rackdc
    - cassandra.swap
    - cassandra.tcp_settings
    - cassandra.ssd_optimize
    - cassandra.disable_zone_reclaim_mode
    - cassandra.cassandra_limits
    - cassandra.disable_swap
    - cassandra.java_hugepages
    - cassandra.optimize_blockdev