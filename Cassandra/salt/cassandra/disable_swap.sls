# /srv/salt/disable_swap.sls

# Ensure swap is disabled immediately
disable_swap:
  cmd.run:
    - name: sudo swapoff --all
    - unless: grep -q '^/dev/' /proc/swaps


# Ensure swap is disabled on boot
disable_swap_persistent:
  file.replace:
    - name: /etc/fstab
    - pattern: '^([^#].*\sswap\s+)(\S+\s+)(\S+\s+)(\S+\s+)(\S+\s+)(\S+)$'
    - repl: '# \1\2\3\4\5\6'
    - show_changes: True

# Apply sysctl settings immediately
apply_sysctl:
  cmd.run:
    - name: sysctl -p /etc/sysctl.conf
    - require:
      - file: disable_swap_persistent
