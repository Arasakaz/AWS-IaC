#! /bin/sh

# nexus_playbook=./../../ansible/openvpn/install_nexus.yml
openvpn_playbook=./../../ansible/openvpn/main.yml
openvpn_script=./../../ansible/openvpn/install2.sh
host=all
# old_ip=\"$(ip -4 addr | sed -ne 's|^.* inet \([^/]*\)/.* scope global.*$|\1|p' | head -1)\"
new_ip=

sed -i'' -e 's/hosts:.*/hosts: '$host'/' $nexus_playbook
sed -i'' -e '149,$d' $nexus_playbook
sed -i'' -e 's/hosts:.*/hosts: '$host'/' $openvpn_playbook
sed -i'' -e '109,$d' $openvpn_playbook
sed -i'' -e 's/IP=REPLACE_ME/IP='$new_ip'/' $openvpn_script
sed -i'' -e '631,639d' $openvpn_script