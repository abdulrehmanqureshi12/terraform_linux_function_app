#!/bin/bash

acr_name="acrbasqaeastusp01.azure

cr.io"

IFS=',' read -ra list <<< "$JSON_REPOS"

for i in "${list[@]}"; do imgPath=$(echo "$i" | awk -F'|'

'{print $NF}')

source=$(echo "$i" | sed 's/IN/g') az acr import --force -n

"$acr_name" --source "$source" -t

"$imgPath"

done
