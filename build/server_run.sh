#!/bin/bash

# Prepares then runs the server

echo ">>> Setting up the db for Django"
python manage.py migrate

echo ">>> Collect statics"
python manage.py collectstatic --noinput

echo ">>> Starting local server"
python manage.py runserver 0.0.0.0:8000
