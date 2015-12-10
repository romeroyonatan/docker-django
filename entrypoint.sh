#!/bin/bash

echo "Migrating database"
python manage.py migrate --noinput
echo "Collecting static"
python manage.py collectstatic --noinput

echo "Starting nginx"
nginx 

echo "Starting UWSGI"
/usr/bin/uwsgi --emperor /etc/uwsgi/vassals 
