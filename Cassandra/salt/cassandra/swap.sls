create_swapfile:
  cmd.run:
    - name: 'fallocate -l 2G /swapfile'
    - unless: 'test -f /swapfile'

set_permissions:
  file.managed:
    - name: /swapfile
    - mode: 600

mkswap:
  cmd.run:
    - name: 'mkswap /swapfile'
    - unless: 'swapon --show | grep /swapfile'

swapon:
  cmd.run:
    - name: 'swapon /swapfile'
    - unless: 'swapon --show | grep /swapfile'

persist_fstab:
  mount.swap:
    - name: /swapfile
    - persist: True
