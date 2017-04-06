#!/bin/bash

# required variables from credentials env file
[ -x credentials.env ] && . credentials.env
[[ "x$TTSLICENSES_ADDR" = "x" ]] && { echo "TTSLICENSES_ADDR must be set." ; exit 1; }
[[ "x$TTSLICENSES_DB_NAME" = "x" ]] && { echo "TTSLICENSES_DB_NAME must be set." ; exit 1; }
[[ "x$TTSLICENSES_DB_USER" = "x" ]] && { echo "TTSLICENSES_DB_USER must be set." ; exit 1; }
[[ "x$TTSLICENSES_DB_PASS" = "x" ]] && { echo "TTSLICENSES_DB_PASS must be set." ; exit 1; }

# back up the database

# are we logged in?
cf apps > /dev/null 2>&1
if $? = "1"
then
	echo "Before running this script, please log in to cloud.gov with \"cf login -o gsa-tts-infrastructure -s licenses-prod -sso\"."
	exit 1
fi
# is the backup plugin installed?
cf plugins | grep -q ^cg-migrate-db
if $? = "0"
then
	# this is an interactive tool that prompts for bucket name, so provide it
	echo "Backup S3 bucket is ttslicenseDbBackup"
	# back up database
	cf export-data
else
	echo "Please install the Cloud Foundry plugin cg-migrate-db. See https://github.com/18F/cg-migrate-db ."
	exit 1
fi

# Deploy the docker image
cf push ttslicenses --docker-image snipe/snipe-it:latest --no-start

# Mysql Parameters
cf set-env ttslicenses MYSQL_PORT_3306_TCP_ADDR $TTSLICENSES_ADDR
cf set-env ttslicenses MYSQL_PORT_3306_TCP_PORT 3306
cf set-env ttslicenses MYSQL_DATABASE $TTSLICENSES_DB_NAME
cf set-env ttslicenses MYSQL_USER $TTSLICENSES_DB_USER
cf set-env ttslicenses MYSQL_PASSWORD $TTSLICENSES_DB_PASS

# Snipe-IT settings
cf set-env ttslicenses APP_ENV production
cf set-env ttslicenses APP_DEBUG false
cf set-env ttslicenses APP_KEY 'base64:MZX1xZptmmE9ZivdA/vLcDLt+fQ8MOZ2vFJmsWzxOv8='
cf set-env ttslicenses APP_URL https://ttslicenses.app.cloud.gov:443
cf set-env ttslicenses APP_TIMEZONE US/Eastern
cf set-env ttslicenses APP_LOCALE en

# unset sensitive envvars
TTSLICENSES_ADDR="" 
TTSLICENSES_DB_NAME="" 
TTSLICENSES_DB_USER=""
TTSLICENSES_DB_PASS="" 
