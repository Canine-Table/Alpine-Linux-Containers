cat > /etc/profile << 'EOS'
[ -e /tmp/.failsafe ] && export FAILSAFE=1

[ -f /etc/banner ] && cat /etc/banner
[ -n "$FAILSAFE" ] && cat /etc/banner.failsafe

grep -Fsq '/ overlay ro,' /proc/mounts && {
        echo 'Your JFFS2-partition seems full and overlayfs is mounted read-only.'
        echo 'Please try to remove files from /overlay/upper/... and reboot!'
}

export PATH="/usr/sbin:/usr/bin:/sbin:/bin"
export HOME=$(grep -e "^${USER:-root}:" /etc/passwd | cut -d ":" -f 6)
export HOME=${HOME:-/root}
export ENV=/etc/shinit
export PS1="$(
        echo '\H:[\u:[\w]]'
        [ "$(id -u)" -eq 0 ] && echo '# ' || echo '$ '
)"

[ -n "$FAILSAFE" ] || {
        for FILE in /etc/profile.d/*.sh; do
                [ -e "$FILE" ] && . "$FILE"
        done
        unset FILE
}

if ( grep -qs '^root::' /etc/shadow && \
     [ -z "$FAILSAFE" ] )
then
cat << EOF
=== WARNING! =====================================
There is no root password defined on this device!
Use the "passwd" command to set up a new password
in order to prevent unauthorized SSH logins.
--------------------------------------------------
EOF
fi
EOS
