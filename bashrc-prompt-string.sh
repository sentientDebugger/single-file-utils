# Intended to be (the contents of) the ~/.bashrc file.

# Changes bash's PS1 to have a 2 line prompt where the first line has the
# datetime and (optionally) the git branch. The second line has the username
# and the working directory.

__prompt_prefix() {
    # @TODO
    # Seems like the $'\x01' and $'\x02' ('[' and ']' respectively) may be
    # optional? Prompt seems to work fine without them?
    # Maybe use only those characters to detect what should be removed by
    # __remove_colors() and __remove_all()?
    white=$'\x01'$(tput setaf 7)$'\x02'
    cyan=$'\x01'$(tput setaf 6)$'\x02'
    reset_txt=$'\x01'$(tput sgr0)$'\x02'

    __remove_all() {
        r=$1
        shift
        for pattern in "$@"; do
            r=${r//"$pattern"/}
        done
        echo "$r"
    }
    __remove_colors() {
        __remove_all "$1" "$white" "$cyan" "$reset_txt"
    }

    dt="$(date '+%Y-%m-%dT%T.%3N%:z')"
    current_branch="$(git branch --show-current 2>/dev/null)"

    prefix_line="${white}${dt}"
    if [[ -n $current_branch ]]; then
        prefix_line="${prefix_line} ${cyan}(${current_branch})"
    fi
    prefix_line="${prefix_line}${reset_txt} "
    nocolor_prefix_line=$(__remove_colors "$prefix_line")

    prefix_line_len="${#nocolor_prefix_line}"
    max_col_count=$(tput cols)
    (( dash_count = max_col_count - prefix_line_len ))
    for (( i=0; i<dash_count; i++ )); do
        prefix_line="${prefix_line}-"
    done

    echo "${prefix_line}"
}
PROMPT_COMMAND='PS1_CMD1=$(__prompt_prefix)'
PS1='${PS1_CMD1}\n\[$(tput setaf 7)\]\u@\w\$\[$(tput sgr0)\] '
