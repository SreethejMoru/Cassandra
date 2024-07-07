create_sources_list:
  file.managed:
    - name: /etc/apt/sources.list.d/corretto.list
    - contents: |
        deb https://apt.corretto.aws stable main
    - user: root
    - group: root
    - mode: 644

update_apt_repository:
  cmd.run:
    - name: apt update
    - require:
      - file: create_sources_list

install_gnupg:
  pkg.installed:
    - name: gnupg
    - refresh: True

add_corretto_gpg_key:
  cmd.run:
    - name: curl -fsSL https://apt.corretto.aws/corretto.key | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/corretto-archive-keyring.gpg
    - unless: test -f /etc/apt/trusted.gpg.d/corretto-archive-keyring.gpg

update_apt_repository_again:
  cmd.run:
    - name: apt update
    - require:
      - cmd: add_corretto_gpg_key

install_corretto_jdk:
  pkg.installed:
    - name: java-1.8.0-amazon-corretto-jdk
    - require:
      - cmd: update_apt_repository_again

set_java_home:
  file.managed:
    - name: /root/.bashrc
    - contents: |
        export JAVA_HOME=/usr/lib/jvm/java-1.8.0-amazon-corretto
        export PATH=$JAVA_HOME/bin:$PATH
    - user: root
    - group: root
    - mode: 644
    - append_if_not_found: True
    - require:
      - pkg: install_corretto_jdk

source_bashrc:
  cmd.run:
    - name: source /root/.bashrc
    - shell: /bin/bash
    - require:
      - file: set_java_home
