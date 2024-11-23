mkdir -p /etc/profile.d/
cat > /etc/profile.d/01-export.sh << 'EOF'
#!/bin/sh
export HOME="$(cd ~ && pwd)"
export USER="$(whoami)"
export GROUPS="$(groups "$USER")"
export ENV="$(
        f="$HOME"/.shinit
        [ -f "$f" -a -r "$f" ] && echo "$f" || false
)" || unset ENV
export PAGER=$(cmd less more most tee) || unset PAGER
export EDITOR=$(cmd nvim vim vi emacs) || unset EDITOR
export AWK=$(cmd mawk nawk awk gawk)
export PS1="$(
        echo '\H:[\u:[\w]]'
        [ "$(id -u)" -eq 0 ] && echo '# ' || echo '$ '
)"

EOF
