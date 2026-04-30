while IFS= read -r line; do
    case "${line:0:2}" in
        '??') ((git__untracked++));;
        U?|?U) ((git__unmerged++));;
        D?|?D) ((git__deleted++));;
        R?|?R) ((git__renamed++));;
        ?[^\ ]) ((git__modified++));;
        [^\ ]?) ((git__staged++));;
    esac
done < <(git status --porcelain)
((git__staged)) && git_text+="+$git__staged "
((git__deleted)) && git_text+="x$git__deleted "
((git__renamed)) && git_text+=">$git__renamed "
((git__modified)) && git_text+="!$git__modified "
((git__untracked)) && git_text+="?$git__untracked "
((git__unmerged)) && git_text+="*$git__unmerged "

