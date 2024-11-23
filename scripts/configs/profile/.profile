export HOME="$(cd ~ && pwd)"
export USER="$(whoami)"
export GROUPS="$(groups "$USER")"

export XDG_CONFIG_HOME="$HOME"/.config
export XDG_RUNTIME_DIR="$HOME"/.docker/run
export DOCKER_HOST=unix://"$XDG_RUNTIME_DIR"/docker.sock
export DOCKERD_BINARY="$HOME"/.docker/bin/dockerd

export ENV="$(
        f="$HOME"/.ashrc
        [ -f "$f" -a -r "$f" ] && echo "$HOME"/.ashrc || false
)" || unset ENV

append_path() {
        case ":$PATH:" in
                *:"$1":*) return 1;;
                *) export PATH="${PATH:+$PATH:}$1";;
        esac

        return 0
}

unset PATH
append_path "$HOME"/.local/bin
append_path "$HOME"/.docker/bin
append_path /usr/local/sbin
append_path /usr/local/bin
append_path /usr/sbin
append_path /usr/bin
append_path /sbin
append_path /bin
