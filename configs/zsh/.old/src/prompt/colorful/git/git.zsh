    local gitdir=$(git rev-parse --git-dir 2>/dev/null)
    if [[ ! -z "$gitdir" && $(git rev-parse --is-inside-work-tree 2>/dev/null) == true ]]; then
        local git_remote_icon='' git_staged=0 git_deleted=0 git_renamed=0 git_modified=0 git_untracked=0 git_unmerged=0 git_branch_tag_location=$(git symbolic-ref --short HEAD 2>/dev/null || git describe --tags --exact-match HEAD 2>/dev/null)
        [[ ! -z "$git_branch_tag_location" ]] && git_branch_tag_location+=' '
        git config --get-regexp '^remote\..*\.url' > /dev/null 2>&1 && ###git-remote-icon###
        while IFS= read -r line; do
            case "${line:0:2}" in
                '??') ((git_untracked++));;
                ?U) ((git_unmerged++));;
                ?D) ((git_deleted++));;
                ?R) ((git_renamed++));;
                ?[^\ ]) ((git_modified++));;
                *) ((git_staged++));;
            esac
        done < <(git status --porcelain)
        ((git_staged)) && git_text+="###git-staged-char###$git_staged "
        ((git_deleted)) && git_text+="###git-deleted-char###$git_deleted "
        ((git_renamed)) && git_text+="###git-renamed-char###$git_renamed "
        ((git_modified)) && git_text+="###git-modified-char###$git_modified "
        ((git_untracked)) && git_text+="###git-untracked-char###$git_untracked "
        ((git_unmerged)) && git_text+="###git-unmerged-char###$git_unmerged "
        git_text+='%f'
    else
        git_text=''
    fi
