source /usr/share/cachyos-fish-config/cachyos-config.fish

# overwrite greeting
# potentially disabling fastfetch
function fish_greeting
     fastfetch \
        --structure "Title:Separator:OS:Kernel:WM:Shell:Terminal:CPU:GPU:Memory:Uptime" \
        --separator " │ " \
        --logo-type small \
        --color-separator "blue"
end


function fish_prompt
    set -l last_status $status
   # set -l cwd (prompt_pwd --full-length-dirs 1)
    set -l cwd (pwd)
    set -l branch (git branch --show-current 2>/dev/null)

    # newline + directory
    echo ""
    set_color brblue; echo -n " $cwd"

    # git branch
    if test -n "$branch"
        set_color brblack; echo -n " on "
        set_color magenta; echo -n " $branch"
    end

    # git dirty indicator
    if git diff --quiet 2>/dev/null && git diff --cached --quiet 2>/dev/null
    else if git rev-parse --git-dir &>/dev/null
        set_color yellow; echo -n " ●"
    end

    echo ""

    # prompt symbol — red if last command failed, green if ok
    if test $last_status -ne 0
        set_color red; echo -n " ❯ "
    else
        set_color green; echo -n " ❯ "
    end

    set_color normal
end

function fish_right_prompt
    set_color brblack
    echo -n (date "+%H:%M")
    set_color normal
end


alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias ll='eza -lah --icons'
alias bye='shutdown now'
alias logout='pkill -KILL -u $USER'
