# /srv/salt/cassandra_rackdc.sls

cassandra_rackdc_properties:
  file.managed:
    - name: /etc/cassandra/cassandra-rackdc.properties
    - user: root
    - group: root
    - mode: 644
    - contents: |
        dc=datacenter1
        rack=rack1

restart_cassandra_service:
  service.running:
    - name: cassandra
    - enable: True
