function ngrep --description "Search inside notes"
    set -l notes_dir ~/Notes
    set -l result (rg --line-number --color=never "" $notes_dir | fzf \
        --delimiter=: \
        --preview 'glow --style dark {1}' \
        --preview-window=right:60%:wrap \
        --prompt='search > ')
    if test -n "$result"
        set -l file (echo $result | cut -d: -f1)
        set -l line (echo $result | cut -d: -f2)
        nvim +$line $file
    end
end
