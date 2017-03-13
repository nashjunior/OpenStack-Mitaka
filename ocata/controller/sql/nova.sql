CREATE DATABASE nova_api;
CREATE DATABASE nova;

GRANT ALL PRIVILEGES ON nova_api.* TO 'nova'@'localhost'  IDENTIFIED BY 'openstack';

GRANT ALL PRIVILEGES ON nova_api.* TO 'nova'@'%'  IDENTIFIED BY 'openstack';

GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'localhost' IDENTIFIED BY 'openstack';

GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'%' IDENTIFIED BY 'openstack';
