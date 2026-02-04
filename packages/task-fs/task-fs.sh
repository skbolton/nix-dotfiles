rm -rf "$HOME/TaskFS"
mkdir "$HOME/TaskFS"
cd "$HOME/TaskFS"

task _projects | while IFS= read -r proj
do
  proj_path=$(tr '.' '/' <<< "$proj")
  mkdir -p "$proj_path"
  echo export TW_PROJECT="'$proj'" > "$proj_path/.envrc"
  direnv allow "$proj_path"
done
