function nn --description "Create new note"
    set -l notes_dir ~/Notes
    mkdir -p $notes_dir
    set -l name (string join '-' $argv)
    if test -z "$name"
        set name (date +%Y-%m-%d)
    end
    nvim $notes_dir/$name.md
end
