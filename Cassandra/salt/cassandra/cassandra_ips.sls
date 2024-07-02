# cassandra_ips.sls
cassandra_ips:
  {% set ips = salt['mine.get']('*', 'ipv4') %}
  {% if ips %}
  {% for ip in ips.values() %}
  - {{ ip[0] }}
  {% endfor %}
  {% else %}
  - "No IP addresses found"
  {% endif %}

{% do salt.pillar.set('cassandra_ips', cassandra_ips) %}
