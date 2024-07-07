# /srv/salt/disable_zone_reclaim_mode.sls

# Ensure zone_reclaim_mode is disabled
disable_zone_reclaim_mode:
  file.append:
    - name: /etc/rc.local
    - text: |
        echo 0 > /proc/sys/vm/zone_reclaim_mode
        touch /var/lock/subsys/disable_zone_reclaim_mode

# Apply the changes immediately
apply_disable_zone_reclaim_mode:
  cmd.run:
    - name: /etc/rc.local
    - watch:
      - file: disable_zone_reclaim_mode
