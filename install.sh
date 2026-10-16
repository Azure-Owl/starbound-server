#!/bin/bash
if [ -z "$STEAM_ACCOUNT" ] || [ -z "$STEAM_PASSWORD" ]; then
    echo "STEAM_ACCOUNT and STEAM_PASSWORD must be set, Starbound can only be downloaded by an account that owns it"
    exit 1
fi

WORKSHOP=/starbound/steamapps/workshop/content/211820
INSTALLED_MODS=/starbound/mods/.workshop-mods

# Remove the workshop mods installed on the previous start, so mods removed from
# MOD_IDS are uninstalled. Mods added manually are kept.
mkdir -p /starbound/mods
if [ -f "$INSTALLED_MODS" ]; then
    while read -r file; do
        rm -rf "/starbound/mods/$file"
    done < "$INSTALLED_MODS"
fi
rm -f "$INSTALLED_MODS"
rm -rf /starbound/steamapps/workshop

run_steamcmd() {
    script=$(mktemp)
    {
        echo "force_install_dir /starbound/"
        echo "login $STEAM_ACCOUNT $STEAM_PASSWORD"
        printf '%s\n' "$@"
        echo "quit"
    } > "$script"
    /steamcmd/steamcmd.sh +runscript "$script"
    status=$?
    rm -f "$script"
    return $status
}

for attempt in 1 2 3; do
    run_steamcmd "app_update 211820 validate" && [ -f /starbound/linux/starbound_server ] && break
    echo "steamcmd failed (attempt $attempt), retrying..."
done

if [ ! -f /starbound/linux/starbound_server ]; then
    echo "starbound_server not found after install, check the Steam login above"
    exit 1
fi
chmod u+x /starbound/linux/starbound_server

for attempt in 1 2 3; do
    downloads=()
    for mod_id in $MOD_IDS; do
        [ -d "$WORKSHOP/$mod_id" ] || downloads+=("workshop_download_item 211820 $mod_id")
    done
    [ ${#downloads[@]} -eq 0 ] && break
    [ "$attempt" -gt 1 ] && echo "Retrying ${#downloads[@]} failed mod download(s) (attempt $attempt)..."
    run_steamcmd "${downloads[@]}"
done

for mod_id in $MOD_IDS; do
    if [ -f "$WORKSHOP/$mod_id/contents.pak" ]; then
        mv "$WORKSHOP/$mod_id/contents.pak" "/starbound/mods/$mod_id.pak"
        echo "$mod_id.pak" >> "$INSTALLED_MODS"
    elif [ -d "$WORKSHOP/$mod_id" ]; then
        for file in "$WORKSHOP/$mod_id"/*; do
            mv "$file" /starbound/mods/
            basename "$file" >> "$INSTALLED_MODS"
        done
    else
        echo "Mod $mod_id was not downloaded, skipping"
    fi
done

cd /starbound/linux
./starbound_server &
SERVER_PID=$!

shutdown() {
    echo "Received stop signal, shutting down Starbound server..."
    kill -INT "$SERVER_PID" 2>/dev/null
    wait "$SERVER_PID"
    exit 0
}
trap shutdown TERM INT

wait "$SERVER_PID"
