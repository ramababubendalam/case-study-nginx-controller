#!/bin/bash

set -e

	cp /opt/maintenance_service/nginx.conf /etc/nginx/conf.d/babylon_maintenance
	python /tpl.py --template-folder=/templates --template-name=nginx.j2 --dest=/etc/nginx/conf.d/default.conf
	python /tpl.py --template-folder=/templates --template-name=routes.j2 --dest=/etc/nginx/conf.d/babylon_routes

# start nginx
nginx -g "daemon off;"