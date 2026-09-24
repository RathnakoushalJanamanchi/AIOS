#!/bin/sh
set -eu

status_file=/var/run/aios-bootstrap.done
failed_file=/var/run/aios-bootstrap.failed
on_exit() {
    result=$?
    if [ "$result" -eq 0 ]; then
        touch "$status_file"
    else
        echo "bootstrap exited with status $result" > "$failed_file"
    fi
}
trap on_exit EXIT

pkg update -f
env ASSUME_ALWAYS_YES=yes pkg install -y __AIOS_PACKAGE_LIST__

pw groupmod video -m aios
sysrc dbus_enable="YES"
sysrc lightdm_enable="YES"
sysrc sshd_enable="YES"

mkdir -p /usr/local/etc/lightdm
cat > /usr/local/etc/lightdm/lightdm.conf <<'EOF'
[Seat:*]
autologin-user=aios
autologin-user-timeout=0
user-session=xfce
greeter-session=lightdm-gtk-greeter
EOF

chown -R aios:aios /home/aios
service dbus start
service lightdm start


