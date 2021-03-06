#!/bin/sh

set -x

###################################################################################################
###################################################################################################
# PREPARATIONS

yum install -y epel-release
yum update -y
yum install -y crudini vim

###################################################################################################
###################################################################################################
# NTP

yum install -y ntp
sed -i -e '/^server.*iburst$/d' /etc/ntp.conf
cat <<EOT >> /etc/ntp.conf
server controller iburst
EOT

systemctl enable ntpd.service
systemctl start ntpd.service

sleep 15

ntpq -c peers
ntpq -c assoc

###################################################################################################
###################################################################################################
# RDO REPOSITORY

yum install -y epel-release
yum install -y http://rdoproject.org/repos/openstack-kilo/rdo-release-kilo.rpm

# NOTE(berendt): Workaround until the completion of the RDO Kilo repository.
cd /etc/yum.repos.d; wget http://trunk.rdoproject.org/centos70/latest-RDO-trunk-CI/delorean.repo

yum upgrade -y

###################################################################################################
###################################################################################################
# SELINUX

yum install -y openstack-selinux
