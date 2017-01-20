#!/bin/bash
# Deploy the docker image
cf push ttslicenses --docker-image snipe/snipe-it:latest --no-start

# Mysql Parameters
cf set-env ttslicenses MYSQL_PORT_3306_TCP_ADDR <replace this value>
cf set-env ttslicenses MYSQL_PORT_3306_TCP_PORT 3306
cf set-env ttslicenses MYSQL_DATABASE <replace this value>
cf set-env ttslicenses MYSQL_USER <replace this value>
cf set-env ttslicenses MYSQL_PASSWORD <replace this value>

# Snipe-IT settings
cf set-env ttslicenses APP_ENV production
cf set-env ttslicenses APP_DEBUG false
cf set-env ttslicenses APP_KEY 'base64:MZX1xZptmmE9ZivdA/vLcDLt+fQ8MOZ2vFJmsWzxOv8='
cf set-env ttslicenses APP_URL https://ttslicenses.app.cloud.gov:443
cf set-env ttslicenses APP_TIMEZONE US/Eastern
cf set-env ttslicenses APP_LOCALE en

