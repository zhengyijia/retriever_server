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

# set global data path
if [ -n "$GLOBAL_DATA_PATH" ]; then
  project_name=$(basename "$(pwd)")
  GLOBAL_DATA_PATH="$GLOBAL_DATA_PATH/$project_name"
else
  GLOBAL_DATA_PATH="$(pwd)"
fi

# build index - e5-base-v2
python src/preprocessing/build_index.py \
  --file_path $GLOBAL_DATA_PATH/data/corpus/wiki18_100w.jsonl \
  --save_path $GLOBAL_DATA_PATH/data/corpus/wiki18_100w_e5_fp16_shard \
  --model_name e5-base-v2 \
  --model_path intfloat/e5-base-v2 \
  --encode_batch_size 4096 \
  --shard_size 100000 \
  --save_fp16
