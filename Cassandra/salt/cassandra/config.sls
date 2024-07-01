# /srv/salt/cassandra/config.sls

{% set cassandra_config_file = '/etc/cassandra/cassandra.yaml' %}

# Step 1: Manage cassandra.yaml configuration file
manage_cassandra_config:
  file.managed:
    - name: {{ cassandra_config_file }}
    - source: salt://cassandra/cassandra.yaml.jinja
    - user: cassandra
    - group: cassandra
    - mode: 644
    - template: jinja
    - context:
        cluster_name: {{ grains['id'] }}_cassandra_cluster  # Example of using a grain
        num_tokens: {{ pillar.get('cassandra_tokens', 256) }}  # Example of using a pillar with a default value
        seed_ips: {{ pillar.get('cassandra_seed_ips', 'node1_private_ip,node2_private_ip,node3_private_ip') }}
        listen_address: {{ grains['ipv4'][0] }}  # Example of using a grain for IP address
        broadcast_rpc_address: {{ pillar.get('cassandra_broadcast_rpc_address', grains['ipv4'][0]) }}  # Example of using a pillar with a default from grains

# Step 2: Restart Cassandra service if configuration changes
restart_cassandra_service:
  service.running:
    - name: cassandra
    - watch:
      - file: manage_cassandra_config
