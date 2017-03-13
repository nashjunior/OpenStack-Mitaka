#!/bin/bash

MARIADB_PASSWORD="openstack"

function assert_superuser {
	[[ "$(id -u)" != "0" ]] && echo "You need to be 'root' dude." 1>&2 && exit 1
}

function create_nova_database
{
	mysql -u root "-p${MARIADB_PASSWORD}" < "/home/openstack/OpenStack-Ocata/ocata/controller/sql/nova.sql"
}

function register_in_keystone
{
	 . "/home/openstack/OpenStack-Ocata/ocata/controller/admin-demo/admin-openrc"
	openstack user create --domain default \
	  --password-prompt nova
	 openstack role add --project service --user nova admin
	openstack service create --name nova \
	  --description "OpenStack Compute" compute
	openstack endpoint create --region RegionOne \
	  compute public http://10.0.0.4:8774/v2.1/%\(tenant_id\)s
	openstack endpoint create --region RegionOne \
	  compute internal http://10.0.0.4:8774/v2.1/%\(tenant_id\)s
	openstack endpoint create --region RegionOne \
	  compute admin http://10.0.0.4:8774/v2.1/%\(tenant_id\)s
}

function install_nova_packages
{
	apt install -y nova-api nova-conductor nova-consoleauth \
	nova-scheduler

	apt install -y novnc
	dpkg -i "/home/openstack/Openstack-Ocata/ocata/controller/nova-novncproxy_15.0.0-0ubuntu1~cloud0_all.deb"
	apt -f install -y
}

function connect_database
{
	su -s /bin/sh -c "nova-manage api_db sync" nova
	su -s /bin/sh -c "nova-manage db sync" nova
}

function restart_services
{
	service nova-api restart
	service nova-consoleauth restart
	service nova-scheduler restart
	service nova-conductor restart
	service nova-novncproxy restart
}

function main
{
	assert_superuser
#	create_nova_database
#	register_in_keystone
#	install_nova_packages
#	cp "/home/openstack/OpenStack-Ocata/ocata/controller/config/nova.conf" "/etc/nova/nova.conf"
#	connect_database
	restart_services
}

main
