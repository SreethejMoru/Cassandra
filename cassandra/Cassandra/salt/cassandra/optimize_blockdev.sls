# /srv/salt/optimize_blockdev.sls

# Check current setra setting for /dev/spinning_disk
check_setra_setting:
  cmd.run:
    - name: blockdev --report /dev/spinning_disk | grep 'setra'
    - unless: test "$(blockdev --report /dev/spinning_disk | grep 'setra' | awk '{print $NF}')" = "128"
    - onlyif: test -e /dev/spinning_disk

# Set optimum setra setting for /dev/spinning_disk
set_optimum_setra:
  cmd.run:
    - name: blockdev --setra 128 /dev/spinning_disk
    - onlyif: test -e /dev/spinning_disk
    - unless: test "$(blockdev --report /dev/spinning_disk | grep 'setra' | awk '{print $NF}')" = "128"
    - require:
      - cmd: check_setra_setting
