# Library containing functions

require_path_entries() {
    local found_home_bin=0
    local found_home_go_bin=0
    for entry in $(echo $PATH | sed 's/:/ /g'); do
        if [[ $entry == "$HOME/bin" ]]; then
            found_home_bin=1
        elif [[ $entry == "$HOME/go/bin" ]]; then
            found_home_go_bin=1
        fi
    done
    echo -n 'monorepo: checking whether $HOME/bin is in PATH... '
    if [[ $found_home_bin == 0 ]]; then
        echo "no (please, add it!)"
        exit 1
    fi
    echo "yes"
    echo -n 'monorepo: checking whether $HOME/go/bin is in PATH... '
    if [[ $found_home_go_bin == 0 ]]; then
        echo "no (please, add it!)"
        exit 1
    fi
    echo "yes"
}
