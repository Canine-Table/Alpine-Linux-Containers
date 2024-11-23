mkdir -p /etc/profile.d/
cat > /etc/profile.d/02-alias.sh << 'EOF'
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

alpine.home.lab:[root:[~/.local/bin]]
# cat /etc/profile.d/02-alias.sh 
alias su='doas su -l'

alias l='ls --color=auto -F' 
alias la='ls --color=auto -ashiFSl'
alias l1='ls --color=auto -a1'
alias ll='ls --color=auto -alF'
alias lA='ls --color=auto -AlF'
alias l.='ls -d .* --color=auto'

alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

alias cls=clear

EOF