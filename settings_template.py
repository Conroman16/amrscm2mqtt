import os

# List of the Meter IDs to watch
# Use empty brackets to read all meters - []
# List may contain only one entry - [12345678]
# or multiple entries - [12345678, 98765432, 12340123]
env_meters = os.getenv('WATCHED_METERS')
if env_meters:
    WATCHED_METERS = [m.strip() for m in env_meters.split(',')]
else:
    WATCHED_METERS = []

# MQTT Server settings
# MQTT_HOST needs to be a string
# MQTT_PORT needs to be an int
# MQTT_USER needs to be a string
# MQTT_PASSWORD needs to be a string
# If no authentication, leave MQTT_USER and MQTT_PASSWORD empty
MQTT_HOST = os.getenv('MQTT_HOST', '127.0.0.1')
MQTT_PORT = int(os.getenv('MQTT_PORT', '1883'))
MQTT_USER = os.getenv('MQTT_USER', '')
MQTT_PASSWORD = os.getenv('MQTT_PASSWORD', '')

# path to rtlamr
RTLAMR = os.getenv('RTLAMR_PATH', '/usr/local/bin/rtlamr')

# path to rtl_tcp
RTL_TCP = os.getenv('RTL_TCP_PATH', '/usr/bin/rtl_tcp')
