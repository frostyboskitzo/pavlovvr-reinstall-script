# pavlovvr-reinstall-script
A script that lets me go full nuclear on PavlovVR Dedicated Server when a steam update breaks it.

Assumes you have two services called `pavlovserver.service` and `pavlovserver-beta.service` on a debian system, and all the prerequisites already installed, according to http://wiki.pavlov-vr.com/index.php?title=Dedicated_server#Starting_Server_Install

These services in my example are configured thusly:
```
root@debian10:/home/steam# cat /etc/systemd/system/pavlovserver.service
[Unit]
Description=Pavlov VR dedicated server

[Service]
Type=simple
WorkingDirectory=/home/steam/pavlovserver
ExecStart=/home/steam/pavlovserver/PavlovServer.sh
RestartSec=1
Restart=always
User=steam
Group=steam

[Install]
WantedBy = multi-user.target
```

```
root@debian10:/home/steam# cat /etc/systemd/system/pavlovserver-beta.service
[Unit]
Description=Pavlov Beta VR dedicated server

[Service]
Type=simple
WorkingDirectory=/home/steam/pavlovserver-beta
ExecStart=/home/steam/pavlovserver-beta/PavlovServer.sh
RestartSec=1
Restart=always
User=steam
Group=steam

[Install]
WantedBy = multi-user.target
```
