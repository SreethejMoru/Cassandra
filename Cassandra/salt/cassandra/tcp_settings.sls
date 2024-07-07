# /srv/salt/cassandra.sls

# Ensure sysctl.conf is managed properly
manage_sysctl_conf:
  file.managed:
    - name: /etc/sysctl.conf
    - contents_pillar: salt://cassandra/sysctl.conf.jinja
    - template: jinja

# Apply the sysctl settings immediately
apply_sysctl:
  cmd.run:
    - name: sysctl -p /etc/sysctl.conf
    - require:
      - file: manage_sysctl_conf

# Optionally restart networking service if needed
restart_networking:
  service.running:
    - name: networking
    - watch:
      - cmd: apply_sysctl
