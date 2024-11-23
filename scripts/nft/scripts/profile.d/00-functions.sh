mkdir -p /etc/profile.d/
cat > /etc/profile.d/00-functions.sh << 'EOF'
#!/bin/sh
# cat /etc/profile.d/00-functions.sh 
# Function to check if any given commands exist in the system's PATH
cmd() {

    while [ ${#@} -gt 0 ]; do

        # Check if the command exists
        command -v "${1}" && return;

        # Move to the next command
        shift;
    done

    # Return failure if no commands are found
    return 1;
}

append_path() {
        [ "$1" = '-p' ] && {
                p=true
                shift
        }
        case ":$PATH:" in
                *:"$1":*) return 1;;
                *) [ "${p:-false}" = true ] &&
                        export PATH="$1${PATH:+:$PATH}" ||
                        export PATH="${PATH:+$PATH:}$1";;
        esac

        unset p
        return 0
}

unique_clist() {
    echo "$@" | awk '{
        unique[$0] = 1;
    } END {
        adrs = length(unique)
        for (i in unique) {
                printf("%s", i)

                if ((adrs = adrs - 1) > 0)
                        printf("%s", ",")
        }
    }'
}

elements() {
        [ "$1" = '-t' ] && {
                T="$2"
                shift 2
        }
        printf "%s" "elements = {"
        unique_clist "$(
                for i in $(seq 1 64); do
                        for j in "$@"; do
                                dig ${T:-} +short "$j" 2> /dev/null
                        done
                done
        )"
        printf "%s\n" "};"
        unset T
}

EOF
