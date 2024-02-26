#!/bin/bash

set -e

root=$(dirname $(dirname "$0"))
echo "root: $root"

output_path=""
datasets="face osm"
num_items="8 6 4"
op_num=100
table_size=100000000

for dataset in $datasets; do
  for num_item in $num_items; do
    "$root/build/microbench" --keys_file="$root/datasets/$dataset" --read=0 --insert=0 --scan=1 --scan_num=100 \
      --table_size=$table_size --init_table_ratio=1 --operations_num=$op_num --thread_num=1 --index=lipp \
      --latency_sample=true --memory=true --num_items=$num_item
    pid=$!
    echo "pid: $pid"
    echo $pid > /sys/fs/cgroup/memlimit/cgroup.procs
    wait $pid
  done
done