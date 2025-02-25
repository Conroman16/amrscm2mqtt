# AMRSCM2MQTT: Send AMR/ERT Utility Meter Data Over MQTT

## Forked from amridm2mqtt but adapted to use SCM instead because that's what my gas meter uses

##### Original code was: (c) 2018 Ben Johnson. Distributed under MIT License.
##### Otherwise the rest is me: (c) 2023 Connor Kennedy. Still distributed under MIT License

Using an [inexpensive rtl-sdr dongle](https://www.amazon.com/s/ref=nb_sb_noss?field-keywords=RTL2832U), it's possible to listen for signals from ERT compatible smart meters using rtlamr. This script runs as a daemon, launches rtl_tcp and rtlamr, and parses the output from rtlamr. If this matches your meter, it will push the data into MQTT for consumption by Home Assistant, OpenHAB, or custom scripts.

## Docker

If you use Docker and would rather launch this under a container see <README.Docker.md>.

## Requirements

Tested under Raspbian 10 (debian buster)

### rtl-sdr package

Install RTL-SDR package

`sudo apt-get install rtl-sdr`

Set permissions on rtl-sdr device

/etc/udev/rules.d/rtl-sdr.rules

`SUBSYSTEMS=="usb", ATTRS{idVendor}=="0bda", ATTRS{idProduct}=="2838", MODE:="0666"`

Prevent tv tuner drivers from using rtl-sdr device

/etc/modprobe.d/rtl-sdr.conf

`blacklist dvb_usb_rtl28xxu`

### git

`sudo apt-get install git`

### pip3 and paho-mqtt

Install pip for python 3

`sudo apt-get install python3-pip`

Install paho-mqtt package for python3

`sudo pip3 install paho-mqtt`

### golang & rtlamr

Install Go programming language & set gopath

`sudo apt-get install golang`

https://github.com/golang/go/wiki/SettingGOPATH

If only running go to get rtlamr, just set environment temporarily with the following command

`export GOPATH=$HOME/go`


Install rtlamr https://github.com/bemasher/rtlamr

`go get github.com/bemasher/rtlamr`

To make things convenient, I'm copying rtlamr to /usr/local/bin

`sudo cp ~/go/bin/rtlamr /usr/local/bin/rtlamr`

## Install

### Clone Repo
Clone repo into opt

`cd /opt`

`git clone git@github.com:Conroman16/amrscm2mqtt.git`

### Configure

Copy template to settings.py

`cd /opt/amrscm2mqtt`

`sudo cp settings_template.py settings.py`

Edit file and replace with appropriate values for your configuration

`sudo nano /opt/amrscm2mqtt/settings.py`

### Install Service and Start

Copy armidm2mqtt service configuration into systemd config

`sudo cp /opt/amrscm2mqtt/amrscm2mqtt.service /etc/systemd/system/amrscm2mqtt.service`

Refresh systemd configuration

`sudo systemctl daemon-reload`

Set amrscm2mqtt to run on startup

`sudo systemctl enable amrscm2mqtt.service`

Start amrscm2mqtt service

`sudo service amrscm2mqtt start`

### Configure Home Assistant

To use these values in Home Assistant, configure the MQTT broker extension to connect to your server of choice, then place the following in configuration.yaml:
```
mqtt:
  sensor:
    - state_topic: "readings/12345678/meter_reading"
      name: "Total Gas Consumption (ft³)"
      device_class: gas
      unit_of_measurement: 'ft³'
      unique_id: total_gas_consumption_cf
      state_class: total_increasing
```

## Testing

Assuming you're using mosquitto as the server, and your meter's id is 12345678, you can watch for events using the command:

`mosquitto_sub -t "readings/12345678/meter_reading"`

Or if you've password protected mosquitto

`mosquitto_sub -t "readings/12345678/meter_reading" -u <user_name> -P <password>`
