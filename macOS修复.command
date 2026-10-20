#!/bin/sh
script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd) || exit 1
PCL_TOOL_DIR="$script_dir" /usr/bin/osascript -l JavaScript "$script_dir/pcl-download-macos.js" "$@"
result=$?
if [ "$#" -lt 2 ]; then
  printf '%s' '按回车关闭……'
  read -r answer
fi
exit "$result"
