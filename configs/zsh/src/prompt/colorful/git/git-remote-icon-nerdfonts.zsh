case "$(git ls-remote --get-url origin)" in
            *github.com*) git_remote_icon=' ';;
            *gitlab.com*) git_remote_icon=' ';;
            *gnu.org*) git_remote_icon=' ';;
            *archlinux.org*) git_remote_icon=' 󰣇';;
            *) git_remote_icon=' ';;
        esac
