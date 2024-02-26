#!/bin/bash

set -e

root=$(dirname $(dirname "$0"))
echo "root: $root"

output_path=""
datasets="books history face osm"
inserts="0 0.5 1"
op_num=1000000
table_size=100000000

for dataset in $datasets; do
  for insert in $inserts; do
    read=$(echo "1 - $insert" | bc)
    "$root/build/microbench" --keys_file="$root/datasets/$dataset" --read=$read --insert=$insert \
      --table_size=$table_size --init_table_ratio=0.5 --operations_num=$op_num --thread_num=1 --index=lipp --latency_sample=true --memory=true
  done
done