# /srv/salt/ssd_optimize.sls

# Ensure the IO scheduler is set to 'deadline' or 'noop'
set_io_scheduler:
  file.append:
    - name: /etc/rc.local
    - text: |
        echo deadline > /sys/block/sda/queue/scheduler
        # or use 'echo noop' if recommended for your setup
        # echo noop > /sys/block/sda/queue/scheduler
        echo 0 > /sys/class/block/sda/queue/rotational
        echo 8 > /sys/class/block/sda/queue/read_ahead_kb
        touch /var/lock/subsys/local

# Apply the changes immediately
apply_ssd_settings:
  cmd.run:
    - name: /etc/rc.local
    - watch:
      - file: set_io_scheduler
