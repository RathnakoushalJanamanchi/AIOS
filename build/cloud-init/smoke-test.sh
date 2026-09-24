#!/bin/sh
set -eu

fail() {
    echo "FAIL: $*" >&2
    exit 1
}

pkg info -e xorg >/dev/null || fail "Xorg package is absent"
pkg info -e xfce >/dev/null || fail "XFCE package is absent"
command -v xfce4-terminal >/dev/null || fail "XFCE Terminal is absent"
command -v xfce4-settings-manager >/dev/null || fail "XFCE Settings is absent"
command -v thunar >/dev/null || fail "Thunar file manager is absent"
service dbus status >/dev/null || fail "D-Bus is not running"
service lightdm status >/dev/null || fail "LightDM is not running"
pgrep -x Xorg >/dev/null || fail "Xorg is not running"
pgrep -u aios -x xfce4-session >/dev/null || fail "XFCE user session is not running"
su -m aios -c 'test -w "$HOME" && touch "$HOME/.aios-smoke" && rm "$HOME/.aios-smoke"' || fail "user storage is not writable"
df -h / >/dev/null || fail "root storage is unavailable"
ifconfig vtnet0 | grep -q 'inet ' || fail "QEMU network interface has no IPv4 address"
test -s /var/log/messages || fail "system log is absent"
logger -p user.notice -t aios-smoke AIOS_SMOKE_OK
sleep 2
grep -q AIOS_SMOKE_OK /var/log/messages || fail "smoke message was not written to syslog"

echo "PASS: desktop, terminal, settings, file manager, storage, networking, and system logging"

