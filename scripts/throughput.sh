#!/bin/bash

set -ex

root=$(dirname $(dirname "$0"))
echo "root: $root"

output_path=""
datasets="face"
op_num=50000000
#inserts="1"
inserts=$(echo "`seq 0 0.25 1`" | bc)
table_size=100000000

for dataset in $datasets; do
  for insert in $inserts; do
    read=$(echo "1 - $insert" | bc)

    "$root/build/microbench" --keys_file="$root/datasets/$dataset" --read=$read --insert=$insert --scan=0 \
      --table_size=$table_size --init_table_ratio=0.5 --operations_num=$op_num --thread_num=1 --index=lipp \
      --latency_sample=true --memory=true --num_items=8 --gap_counts=1000000:1,100000:2,-1:5

    "$root/build/microbench" --keys_file="$root/datasets/$dataset" --read=$read --insert=$insert \
      --table_size=$table_size --init_table_ratio=0.5 --operations_num=$op_num --thread_num=1 --index=lipp \
      --latency_sample=true --memory=true --num_items=4 --gap_counts=1000000:0,100000:0,-1:0
  done
done
