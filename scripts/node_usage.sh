#!/bin/bash

set -e

root=$(echo "$0" | awk -F '/' '{print $1}')
echo "$root"

output_path=""
datasets="books history fb osm"
op_num=100
table_size=1000000

for dataset in $datasets; do
  "$root/build/microbench" --keys_file="$root/datasets/$dataset" --read=0 --insert=0 --scan=1 --scan_num=100 \
    --table_size=$table_size --init_table_ratio=1 --operations_num=$op_num --thread_num=1 --index=lipp
done