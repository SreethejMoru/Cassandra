# cassandra.sls

cassandra-package:
  pkg.installed:
    - name: cassandra

cassandra-config:
  file.managed:
    - name: /etc/cassandra/cassandra.yaml
    - source: salt://cassandra/cassandra.yaml.jinja
    - template: jinja
    - context:
        cassandra_ips: "{% for ip in salt['mine.get']('*', 'ipv4').values() %}{{ ip }}{% if not loop.last %},{% endif %}{% endfor %}"
    - watch_in:
      - service: cassandra-service

cassandra-service:
  service.running:
    - name: cassandra
    - enable: True
    - reload: True


