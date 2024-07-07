install_curl:
  pkg.installed:
    - name: curl
    - refresh: True
    
add_cassandra_keys:
  cmd.run:
    - name: curl -o /etc/apt/keyrings/apache-cassandra.asc https://downloads.apache.org/cassandra/KEYS
    - require:
      - pkg: curl
    - unless: test -f /etc/apt/keyrings/apache-cassandra.asc
