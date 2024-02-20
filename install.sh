#!/bin/bash
#Install the Starbound dedicated server
/steamcmd/steamcmd.sh \
    +force_install_dir /starbound/ \
    +login ${STEAM_ACCOUNT} ${STEAM_PASSWORD} \
    +app_update 211820 validate \
    +quit

chmod +x /starbound/linux/starbound_server

#Build the mod install script
echo force_install_dir /starbound/ >> /steamcmd/installmods.txt
echo login ${STEAM_ACCOUNT} ${STEAM_PASSWORD} >> /steamcmd/installmods.txt

rm /starbound/mods/*

for mod_id in ${MOD_IDS}
do
  echo workshop_download_item 211820 $mod_id >> /steamcmd/installmods.txt
done

echo quit >> /steamcmd/installmods.txt

#install Mods
/steamcmd/steamcmd.sh +runscript installmods.txt

#Move all content.pak files from each mod to the mods folder and rename them
for mod_id in ${MOD_IDS}
do
  if [ -f /starbound/steamapps/workshop/content/211820/$mod_id/contents.pak ]
  then
    mv /starbound/steamapps/workshop/content/211820/$mod_id/contents.pak /starbound/mods/$mod_id.pak
  else
    mv -v /starbound/steamapps/workshop/content/211820/$mod_id/* /starbound/mods/
  fi
done

#Run the server
cd /starbound/linux
./starbound_server

exit
