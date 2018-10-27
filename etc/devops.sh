#! /bin/bash 
#
# Owner: Solomon Xie
# Email: 14041622+solomonxie@users.noreply.github.com


filter_folder_contain_less_files(){
    for F in ./* ;do
        COUNT=$(find "$F" -type f | wc -l)
        # echo $COUNT
        if [ $COUNT -lt 3 ]; then
            # echo "$F"
            echo mv "$F" "./Various.Artists"
        fi
    done
}