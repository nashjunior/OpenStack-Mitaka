
function assert_superuser {
	[[ "$(id -u)" != "0" ]] && echo "You need to be 'root' dude." 1>&2 && exit 1
}

function install_identity_packages
{
	apt install memcached python-memcache
}

function config_memcached
{
	cp "/home/openstack/ocata/controller/config/memcached.conf" "/etc/memcached.conf"
}

function restart_services
{
	service memcached restart
}

function main
{
	assert_superuser
	install_identity_packages
	config_memcached
	
}

main
