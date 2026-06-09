#~~set_prefix colorful_git~~#
    local dir="$(git rev-parse --git-dir 2>/dev/null)"
    if [[ ! -z "$dir" && "$(git rev-parse --is-inside-work-tree 2>/dev/null)" == true ]]; then
        local remote_icon='' staged=0 deleted=0 renamed=0 modified=0 untracked=0 unmerged=0 branch_tag_location="$(git symbolic-ref --short HEAD 2>/dev/null || git describe --tags --exact-match HEAD 2>/dev/null)"
        [[ ! -z "$branch_tag_location" ]] && branch_tag_location+=' '
        git config --get-regexp '^remote\..*\.url' >/dev/null 2>&1 && #~~remote~~#
        git_text="%F{166}[#~~char logo~~#$remote_icon] $branch_tag_location"
        while IFS= read -r line; do
            case "${line:0:2}" in
                '??') ((untracked++));;
                ?U) ((unmerged++));;
                ?D) ((deleted++));;
                ?R) ((renamed++));;
                ?[^\ ]) ((modified++));;
                [^\ ]?) ((staged++));;
            esac
        done < <(git status --porcelain)
        ((staged)) && git_text+="#~~char staged~~#$staged "
        ((deleted)) && git_text+="#~~char deleted~~#$deleted "
        ((renamed)) && git_text+="#~~char renamed~~#$renamed "
        ((modified)) && git_text+="#~~char modified~~#$modified "
        ((untracked)) && git_text+="#~~char untracked~~#$untracked "
        ((unmerged)) && git_text+="#~~char unmerged~~#$unmerged "
        [[ -f "$dir/logs/refs/stash" ]] && () { git_text+="#~~char stash~~#$#" } ${(f)"$(<$dir/logs/refs/stash)"}
        git_text+='%f'
    else
        git_text=''
    fi#~~set_prefix colorful_precmd~~#
