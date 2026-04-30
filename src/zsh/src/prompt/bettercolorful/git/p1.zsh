local git__gitdir=$(git rev-parse --git-dir 2>/dev/null)
if [[ ! -z "$git__gitdir" && $(git rev-parse --is-inside-work-tree 2>/dev/null) == true ]]; then
    local git__remote_icon='' git__staged=0 git__deleted=0 git__renamed=0 git__modified=0 git__untracked=0 git__unmerged=0 git__branch_tag_location=$(git symbolic-ref --short HEAD 2>/dev/null || git describe --tags --exact-match HEAD 2>/dev/null)
    [[ ! -z "$git__branch_tag_location" ]] && git__branch_tag_location+=' '
    git config --get-regexp '^remote\..*\.url' > /dev/null 2>&1 && 
