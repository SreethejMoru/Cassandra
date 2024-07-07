update_apt_repository_cassandra:
  cmd.run:
    - name: apt-get update

install_cassandra:
  pkg.installed:
    - name: cassandra
    - require:
      - cmd: update_apt_repository_cassandra

start_cassandra_service:
  service.running:
    - name: cassandra
    - enable: True
    - require:
      - pkg: install_cassandra

check_cassandra_status:
  cmd.run:
    - name: service cassandra status
    - require:
      - service: start_cassandra_service
