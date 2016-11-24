# led-buildstatus-nodemcu-lua
Lua version of the led-buildstatus-nodemcu-arduino project.
The script will poll a http server and drive a ws2812 based ledstrip
according to the received data.

## Building the firmware
The NodeMCU-firmware can be build on https://nodemcu-build.com. Make
sure to add the 'http' and 'ws2812' modules.
