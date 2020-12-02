#!/usr/bin/env bash
if [[ -z ${1} ]]; then
	echo "Please input url: "
	read newurl
else
	newurl=${1}
fi
url=$(echo ${newurl} | sed -e 's/^http:/https:/' -e 's/^mbrows:/https:/' | sed '/^http/! s_\(.*\)_https://\1_' ) # https everywhere plugin
htmlfile="$(mktemp -u)" #Save the file here
wget -q "${url}" -O "${htmlfile}"  # Get the file
function print_img {
    tempfile="$(mktemp -u)"
    wget -q "${1}" -O "${tempfile}"
    ~/.cargo/bin/viu "${tempfile}"  2>/dev/null # cargo install viu
    rm "${tempfile}"
}
function display_text {
    OLDIFS=${IFS}
    IFS=$'\n'
    for line in $(cat "${htmlfile}" | \
        html2markdown --no-wrap-links --no-skip-internal-links) ; do # sudo apt install python3-html2text
        echo "${line}" | egrep -q '!\[.*\]\(http.*\)'
        if [[ "${?}" == "0" ]]; then
            img=$(echo "${line}"|sed 's/.*!\[.*\](\(.*\)).*(.*/\1/g') 
            print_img "${img}"
        else
            echo "${line}" | egrep -q '\]\(/.*\)'
            if [[ "${?}" == "0" ]]; then
                echo "${line}"  | sed 's_\](/_]('${url}'/_' | sed -e 's_https://_mbrows://_' -e 's_http://_mbrows://_'
            else
                echo "${line}" | sed -e 's_https://_mbrows://_' -e 's_http://_mbrows://_'
            fi
        fi
    done
    IFS="${OLDIFS}"
}
echo "$(display_text)" | less -R 
rm "${htmlfile}"
