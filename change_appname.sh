#! /bin/bash

#
# Change application name
#

project_home=$(cd $(dirname $0)/../ && pwd)

current_appname=$(cat ${project_home}/etc/appname)

usage_exit() {
    cat << EOF
Usage: ./change_appname [new_appname]

    current_appname is :${current_appname}

EOF
    exit 1;
}

camelize() {
    local material=$1

    words=$(echo ${material} | sed -e 's/_\|-/ /g')
    camelized=""
    for word in ${words}; do
        head=$(echo "${word:0:1}" | tr '[a-z]' '[A-Z]')
        flagment=$(echo "${word}" | sed "s/^./${head}/g")
        camelized="${camelized}${flagment}"
    done
    echo ${camelized}
}

change_appname() {
    local new_appname=$1
    local new_appname_camelized=$(camelize ${new_appname})
    local current_appname_camelized=$(camelize ${current_appname})

    git -c color.ui=false grep -l ${current_appname} \
        | xargs perl -pi -e "s/${current_appname}/${new_appname}/g"
    git -c color.ui=false grep -l ${current_appname_camelized} \
        | xargs perl -pi -e "s/$current_appname_camelized/$new_appname_camelized/g"
}

main() {
    if [ $# -eq 0 ];then
        usage_exit
    else
        dir=$(pwd)
        cd ${project_home}
        change_appname "$@"
        cd ${dir}
    fi
}

main "$@" && exit 0;

