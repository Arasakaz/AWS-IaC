#!/bin/bash

declare -A resource_map
while read -r old_resource new_resource; do
    resource_map["$old_resource"]="$new_resource"
done < mappings.txt

for old_name in "${!resource_map[@]}"; do
    new_name="${resource_map[$old_name]}"
    terraform state mv "$old_name" "$new_name"
done

terraform plan