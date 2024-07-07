# /srv/salt/java_hugepages.sls

# Ensure Transparent Hugepages defragmentation is disabled
disable_transparent_hugepages_defrag:
  cmd.run:
    - name: echo never | sudo tee /sys/kernel/mm/transparent_hugepage/defrag
    - require:
      - pkg: linux-image-extra-$(uname -r)
    - unless: test "$(cat /sys/kernel/mm/transparent_hugepage/defrag)" = "never"

# Apply sysctl settings immediately
apply_sysctl:
  cmd.run:
    - name: sysctl -p /etc/sysctl.conf
