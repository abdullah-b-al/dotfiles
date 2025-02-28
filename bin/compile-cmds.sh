#!/usr/bin/env bash

programs=()
programs+=("zig build")
programs+=("zig test")
programs+=("zig run")
programs+=("go run")
programs+=("go build")
programs+=("ocaml")
programs+=("odin run")
programs+=("odin build")
programs+=("odin test")
programs+=("valgrind")

list_path="$HOME/.local/share/compile_commands_list"
touch "$list_path"

add_from_list() {
    command="$(echo "$@")"; [ -z "$command" ] && exit 1

    for prog in "${programs[@]}"; do
        echo "$command" | grep "$prog" && {
            add_command "$command";
            exit 0;
        }
    done
}

add_command() {
    command="$(echo "$@")"; [ -z "$command" ] && exit 1

    delete_command "$command"
    echo "$(pwd),$command" >> "$list_path"
}

delete_command() {
    command="$(echo "$@")"; [ -z "$command" ] && exit 1

    without_cwd_commands="$(grep -v $(pwd) "$list_path" )"
    cwd_commands="$(grep $(pwd) "$list_path"  | grep -v "$command$")"
    echo "$cwd_commands" > "$list_path"
    echo "$without_cwd_commands" >> "$list_path"
}

list() {
    cat "$list_path" | cut -d , -f 2
}

list_in_cwd() {
    grep -F "$(pwd)," "$list_path" | cut -d , -f 2
}

if [ "$1" = "--help" ] || [ -z "$1" ]; then
    pat="^.*()\s*{"
    echo "Avaliable commands:"
    grep "$pat" "$0" | grep -v "^_" | cut -f 1 -d "("
    exit 0
fi

# If an argument is provided then run the function with the same name
# Make sure the argument matches one of the functions
if grep -q "^$1()\s*{" "$0"; then
    func="$1"
    shift 1
    "$func" "$@"
else
    echo "Command doesn't exist"
    exit 1
fi
