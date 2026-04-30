make_prompt() {
    local HOST_LEN=$(( ${#HOST%%.*} + 1 ))
    local USER_LEN=$(( ${#USER} + 5 ))
    local PWD_LEN="${#${PWD/#$HOME/~}}"
    local EXIT_CODE_LEN=$(( ${#?} + 2 )) 
    local JOB_COUNT=${#jobstates}
    if (( JOB_COUNT >= 2 )); then JOBS_LEN=$((
    HOST_LEN_FULL=$(( HOST_LEN + 5 )) PWD_LEN_FULL=$(( PWD_LEN + 4 ))
}
