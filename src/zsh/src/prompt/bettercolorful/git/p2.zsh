case "$(git ls-remote --get-url origin)" in
    *github.com*) git__remote_icon=' ';;
    *gitlab.com*) git__remote_icon=' ';;
    *gnu.org*) git__remote_icon=' ';;
    *archlinux.org*) git__remote_icon=' 󰣇';;
    *) git__remote_icon=' ';;
esac

