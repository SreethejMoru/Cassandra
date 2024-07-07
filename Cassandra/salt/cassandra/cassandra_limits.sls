# /srv/salt/cassandra_limits.sls

# Ensure pam_limits.so is enabled in /etc/pam.d/su
enable_pam_limits:
  file.replace:
    - name: /etc/pam.d/su
    - pattern: '#session\s+required\s+pam_limits.so'
    - repl: 'session    required   pam_limits.so'
    - show_changes: True

# Ensure vm.max_map_count is set in /etc/sysctl.conf
set_vm_max_map_count:
  file.append:
    - name: /etc/sysctl.conf
    - text:
        - vm.max_map_count = 1048575

# Ensure limits are set in /etc/security/limits.d/cassandra.conf
set_cassandra_limits:
  file.managed:
    - name: /etc/security/limits.d/cassandra.conf
    - source: salt://cassandra/cassandra.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - require:
      - file: enable_pam_limits
      - file: set_vm_max_map_count

# Apply sysctl settings immediately
apply_sysctl:
  cmd.run:
    - name: sysctl -p /etc/sysctl.conf
    - require:
      - file: set_vm_max_map_count

# Restart Cassandra service to apply new limits
restart_cassandra:
  service.running:
    - name: cassandra
    - watch:
      - cmd: apply_sysctl
      - file: set_cassandra_limits
