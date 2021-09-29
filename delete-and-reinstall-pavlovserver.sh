#!/bin/bash
echo "Nuclear option deletes Steam and Pavlov and reinstalls both; the only winning move was not to play."
read -p "Control+C or terminate this script to prevent a complete wipe of Pavlov; enter anything to continue." nuclearoption
echo "****************************************************************************************************"

# Backing up Configs, just in case
date=$(date +%s)
mkdir -p /home/steam/pavlovserverconfig/$date/
cp /home/steam/pavlovserver/Pavlov/Saved/Config/RconSettings.txt /home/steam/pavlovserverconfig/$date/RconSettings-main.txt
cp /home/steam/pavlovserver-beta/Pavlov/Saved/Config/RconSettings.txt /home/steam/pavlovserverconfig/$date/RconSettings-beta.txt
cp /home/steam/pavlovserver/Pavlov/Saved/Config/LinuxServer/Game.ini /home/steam/pavlovserverconfig/$date/Game-main.ini
cp /home/steam/pavlovserver-beta/Pavlov/Saved/Config/LinuxServer/Game.ini /home/steam/pavlovserverconfig/$date/Game-beta.ini
ln -sf /home/steam/pavlovserverconfig/$date/RconSettings-main.txt /home/steam/pavlovserverconfig/RconSettings-main.txt
ln -sf /home/steam/pavlovserverconfig/$date/RconSettings-beta.txt /home/steam/pavlovserverconfig/RconSettings-beta.txt
ln -sf /home/steam/pavlovserverconfig/$date/Game-main.ini /home/steam/pavlovserverconfig/Game-main.ini
ln -sf /home/steam/pavlovserverconfig/$date/Game-beta.ini /home/steam/pavlovserverconfig/Game-beta.ini

# Stopping and Removing all pavlov and steam stuff
echo "*******************************"
echo "Stopping Pavlov and Pavlov Beta"
echo "*******************************"
systemctl stop pavlovserver
systemctl stop pavlovserver-beta

echo "*******************************************"
echo "Removing Steam and Pavlov files and folders"
echo "*******************************************"
rm -rf /home/steam/Steam
rm -rf /home/steam/.steam
rm -rf /tmp/workshop
rm -rf /home/steam/pavlovserver
rm -rf /home/steam/pavlovserver-beta

# Reinstall Steam
echo "******************"
echo "Reinstalling Steam"
echo "******************"
su -c "mkdir /home/steam/Steam" -s /bin/sh steam
su -c "curl -sqL 'https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz' | tar zxvf - --directory /home/steam/Steam/" -s /bin/sh steam
su -c "/home/steam/Steam/steamcmd.sh +login anonymous +app_update 1007 +exit" -s /bin/sh steam

# Reinstall Pavlov Main
echo "************************"
echo "Reinstalling Pavlov Main"
echo "************************"
su -c "/home/steam/Steam/steamcmd.sh +login anonymous +force_install_dir /home/steam/pavlovserver +app_update 622970 +exit" -s /bin/sh steam
su -c "cp /home/steam/Steam/steamapps/common/Steamworks\ SDK\ Redist/linux64/steamclient.so /home/steam/pavlovserver/Pavlov/Binaries/Linux/steamclient.so" -s /bin/sh steam
chmod +x /home/steam/pavlovserver/PavlovServer.sh
systemctl start pavlovserver.service
sleep 10
systemctl stop pavlovserver.service

# Reinstall Pavlov Beta
echo "************************"
echo "Reinstalling Pavlov Beta"
echo "************************"
su -c "/home/steam/Steam/steamcmd.sh +login anonymous +force_install_dir /home/steam/pavlovserver-beta +app_update 622970 -beta beta_server +exit" -s /bin/sh steam
su -c "cp /home/steam/Steam/steamapps/common/Steamworks\ SDK\ Redist/linux64/steamclient.so /home/steam/pavlovserver-beta/Pavlov/Binaries/Linux/steamclient.so" -s /bin/sh steam
chmod +x /home/steam/pavlovserver-beta/PavlovServer.sh
systemctl start pavlovserver-beta.service
sleep 10
systemctl stop pavlovserver-beta.service

# Copy over config files and fix permissions
echo "************************************************"
echo "Copying over config files and fixing permissions"
echo "************************************************"
su -c "cp /home/steam/pavlovserverconfig/Game-main.ini /home/steam/pavlovserver/Pavlov/Saved/Config/LinuxServer/Game.ini" -s /bin/sh steam
su -c "cp /home/steam/pavlovserverconfig/Game-beta.ini /home/steam/pavlovserver-beta/Pavlov/Saved/Config/LinuxServer/Game.ini" -s /bin/sh steam
su -c "cp /home/steam/pavlovserverconfig/RconSettings-main.txt /home/steam/pavlovserver/Pavlov/Saved/Config/RconSettings.txt" -s /bin/sh steam
su -c "cp /home/steam/pavlovserverconfig/RconSettings-beta.txt /home/steam/pavlovserver-beta/Pavlov/Saved/Config/RconSettings.txt" -s /bin/sh steam
chown -R steam:steam /home/steam/
echo "**********************************************************************************"
echo "Steam Reinstalled, Pavlov Reinstalled, Game.ini and RconSettings.txt Files updated"
echo "**********************************************************************************"
