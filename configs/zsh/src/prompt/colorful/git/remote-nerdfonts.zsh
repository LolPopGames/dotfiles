case "$(git ls-remote --get-url origin)" in
            *github.com*) remote_icon=' ';;
            *gitlab.com*) remote_icon=' ';;
            *gnu.org*) remote_icon=' ';;
            *archlinux.org*) remote_icon=' 󰣇';;
            *) remote_icon=' ';;
        esac