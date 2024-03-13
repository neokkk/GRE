#!/bin/bash

set -e

root=$(dirname $(dirname "$0"))
echo "root: $root"

output_path=""
datasets="face"
num_items="8"
gap_counts_first="1"
gap_counts_second="2"
gap_counts_third="5"
op_num=100000000
table_size=100000000

for dataset in $datasets; do
  for num_item in $num_items; do
    for gap_count_f in $gap_counts_first; do
      for gap_count_s in $gap_counts_second; do
        for gap_count_t in $gap_counts_third; do
          "$root/build/microbench" --keys_file="$root/datasets/$dataset" --read=0.5 --insert=0.5 --scan=0 \
            --table_size=$table_size --init_table_ratio=1 --operations_num=$op_num --thread_num=1 --index=lipp \
            --latency_sample=true --memory=true --num_items=$num_item --gap_counts=1000000:$gap_count_f,100000:$gap_count_s,-1:$gap_count_t
        done
      done
    done
  done
done