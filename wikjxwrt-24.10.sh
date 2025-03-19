#!/bin/bash

export TZ="Asia/Hong_Kong"

if [[ -n "$1" ]]; then
    target_dir="$1"
else
    echo "Usage: $0 <target_directory>"
    exit 1
fi
if [[ ! -d "$target_dir" ]]; then
    echo "Error: Directory '$target_dir' does not exist."
    exit 1
fi

cd "$target_dir"

current_dir=$(basename "$PWD")
parent_dir=$(basename "$(dirname "$PWD")")
title="<a href=\"https://openwrt-lite.pages.dev/\">&#x1F4C2;</a>/${parent_dir}/23.05/${current_dir}/"

cat <<EOF > index.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>OpenWrt Lite Repo</title>
    <style>
        table { border-collapse: collapse; width: 100%; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        th { background-color: #f2f2f2; }
        a { color: inherit; text-decoration: none; }
        a:hover { text-decoration: underline; }
        footer { margin-top: 20px; text-align: center; font-size: 14px; color: #666; }
    </style>
</head>
<body>
    <h2>${title}</h2>
    <table>
        <thead>
            <tr>
                <th>File Name</th>
                <th>Size</th>
                <th>Date</th>
            </tr>
        </thead>
        <tbody>
EOF

format_size() {
    size=$1
    if (( size >= 1048576 )); then
        printf "%.2f MiB" "$(awk "BEGIN {printf \"%.2f\", $size / 1048576}")"
    else
        printf "%.2f KiB" "$(awk "BEGIN {printf \"%.2f\", $size / 1024}")"
    fi
}

for file in *; do
    if [ -f "$file" ] && [[ "$file" != "index.html" ]] && [[ ! "$file" =~ \.sh$ ]]; then
        raw_size=$(stat --format="%s" "$file")
        size=$(format_size "$raw_size")
        mtime=$(stat --format="%y" "$file" | cut -d'.' -f1)
        mtime=$(echo "$mtime" | sed -E 's/(.*)/\1 (HKT)/')
        echo "<tr><td><a href=\"$file\">$file</a></td><td>$size</td><td>$mtime</td></tr>" >> index.html
    fi
done

cat <<EOF >> index.html
        </tbody>
    </table>
    <footer>
        <p>&copy; <a href="https://github.com/wixxm/wikjxwrt" target="_blank">OpenWrt-Lite</a> | Licensed under <a href="https://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html" target="_blank">GPL-2.0</a></p>
    </footer>
</body>
</html>
EOF

echo "index.html has been generated."
