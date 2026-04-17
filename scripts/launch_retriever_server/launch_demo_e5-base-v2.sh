#!/bin/bash
set -e

# print slurm job info
echo "==============================="
echo "Slurm job info:"
echo "Job ID: $SLURM_JOB_ID"
echo "Node name: $SLURMD_NODENAME"
echo "Node list: $SLURM_NODELIST"
echo "Start time: $(date)"
echo "==============================="

# set up python environment
source ~/common/init_rag_env.sh

# change to project root directory
cd ../..
export PYTHONPATH=$PYTHONPATH:$(pwd)/src

# if CUDA_VISIBLE_DEVICES is not set, use all GPUs
if [ -z "$CUDA_VISIBLE_DEVICES" ]; then
    NUM_GPUS=$(nvidia-smi --query-gpu=name --format=csv,noheader | wc -l)
    CUDA_VISIBLE_DEVICES=$(seq -s, 0 $((NUM_GPUS - 1)))
    export CUDA_VISIBLE_DEVICES
else
    NUM_GPUS=$(echo "$CUDA_VISIBLE_DEVICES" | tr -d ' ' | awk -F',' '{print NF}')
fi
echo "Using GPUs: $CUDA_VISIBLE_DEVICES"
echo "NUM_GPUS: ${NUM_GPUS}"

export VLLM_WORKER_MULTIPROC_METHOD=spawn

# set global data path
if [ -n "$GLOBAL_DATA_PATH" ]; then
  project_name=$(basename "$(pwd)")
  GLOBAL_DATA_PATH="$GLOBAL_DATA_PATH/$project_name"
else
  GLOBAL_DATA_PATH="$(pwd)"
fi

RETRIEVER_CONFIG="e5-base-v2"

python src/launch_retriever_server.py \
  --config-path $(pwd)/config \
  --config-name retriever_server \
  retriever=$RETRIEVER_CONFIG \
  "retriever.corpus_path='$GLOBAL_DATA_PATH/data/corpus'" \
  server.port=8003 \
  retriever.corpus_index_folder='wiki18_demo_e5-base-v2_fp16_shard' \
  retriever.corpus_file='wiki18_demo.jsonl'
