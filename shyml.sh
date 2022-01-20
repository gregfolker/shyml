#!/usr/bin/env bash

parse_yaml() {
   local yaml="$1"
   local prefix="$2"

   local s='[[:space:]]*'
   local w='[a-zA-Z0-9_]*'
   local fs=$(echo @ | tr @ '\034')

   sed -ne "s|^\($s\):|\1|" \
      -e "s|^\($s\)\($w\)$s:$s[\"']\(.*\)[\"']$s\$|\1$fs\2$fs\3|p" \
      -e "s|^\($s\)\($w\)$s:$s\(.*\)$s\$|\1$fs\2$fs\3|p"  $yaml \
   | awk -F$fs '{
      indent = length($1) / 2;
      vname[indent] = $2;
      for (i in vname) {if (i > indent) {delete vname[i]}}
      if (length($3) > 0) {
         vn="";
         for (i = 0; i < indent; i++) {vn=(vn)(vname[i])("_")}
         printf("%s%s%s=\"%s\"\n", "'$prefix'",vn, $2, $3);
      }
   }'
}

main () {
   local line
   local yaml="$1"
   local prefix="$2"
   if [[ ! -f $yaml ]] ; then echo "$yaml: File not found." && exit 1; fi
   echo '('
   while read -r line ; do
      line=$(echo $line | tr -d '"')
      IFS=$'\n' read -d "" -ra params <<< "${line//'='/$'\n'}"
      echo "['${params[0]}']='${params[1]}'"
   done < <(parse_yaml $yaml $prefix)
   echo ')'
}

main "$@"
