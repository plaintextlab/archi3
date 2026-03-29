function note --description "Browse notes with fzf"
    set -l notes_dir ~/Notes
    mkdir -p $notes_dir
    set -l file (find $notes_dir -name "*.md" | sort -r | fzf \
        --preview 'glow --style dark {}' \
        --preview-window=right:60%:wrap \
        --prompt='notes > ' \
        --bind "ctrl-d:execute(rm {})+reload(find $notes_dir -name '*.md' | sort -r)")
    if test -n "$file"
        nvim $file
    end
end
