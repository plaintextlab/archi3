function pkg
    set native  (pacman -Qen | awk '{printf "%-40s \033[32m[repo]\033[0m\n", $0}')
    set foreign (pacman -Qm  | awk '{printf "%-40s \033[35m[aur]\033[0m\n",  $0}')

    printf '%s\n' $native $foreign \
    | sort \
    | fzf --ansi \
          --height=80% \
          --layout=reverse \
          --border=rounded \
          --header='Manual packages  (enter=info  ctrl-r=remove)' \
          --preview='pacman -Qi {1}' \
          --preview-window=right:50%:wrap \
          --bind='enter:execute(pacman -Qi {1} | less)' \
          --bind='ctrl-r:execute(paru -Rns {1})'
end
