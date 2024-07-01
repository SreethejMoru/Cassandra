add_cassandra_repository:
  file.managed:
    - name: /etc/apt/sources.list.d/cassandra.sources.list
    - contents: |
        deb [signed-by=/etc/apt/keyrings/apache-cassandra.asc] https://debian.cassandra.apache.org 41x main
    - user: root
    - group: root
    - mode: 644
    - append_if_not_found: True

update_apt_repository_final:
  cmd.run:
    - name: apt-get update -y
    - require:
      - file: add_cassandra_repository