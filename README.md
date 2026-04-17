# Quick start
## launch a (demo) REST server
```
cd scripts/launch_retriever_server
bash launch_demo_e5-base-v2.sh
```

The demo dataset here is just a small subset of the full wiki18 corpus.

## test the server
```
cd scripts/launch_retriever_server
bash test_get_retriever_info.sh
bash test_retrieve.sh
```

The server provides a REST API wrapper around a local FAISS-based retriever.
Alternatively, you can run the retriever directly without starting the REST server (see `src/launch_retriever_server.py` for details).

# Build your own index

1. Place `wiki18_100w.jsonl` (your corpus) in the `data/corpus` directory.
2. Run the script `bash build_corpus_index.sh` (adjust `encode_batch_size` based on your GPU memory).



