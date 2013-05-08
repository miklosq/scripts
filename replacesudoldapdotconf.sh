#!/bin/sh
if grep "6\.3" /etc/redhat-release; then {
sed -i "/ldap:\/\/eos.obs.local/s|$| ldap://syang.obs.local|" /etc/sudo-ldap.conf
grep "^uri" /etc/sudo-ldap.conf
} ; else echo "this box is not a rhel6.3"; fi
