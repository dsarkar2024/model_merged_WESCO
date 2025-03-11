#!/bin/bash


SOURCE_DIR="Sweep/data_WESCO/cache"
DEST_DIR="Sweep/GNN_model/data/WESCO"
MODELS_FOLDER="models"
OUTPUT_FOLDER="outputs"

mkdir -p "$DEST_DIR"
mkdir -p "$MODELS_FOLDER"
mkdir -p "$OUTPUT_FOLDER"



echo "Copying Adjacency Matrix from $SOURCE_DIR to $DEST_DIR..."
cp -r "$SOURCE_DIR/adj_mx.pkl" "$DEST_DIR"

# echo "Copying sweep datasets from $SOURCE_DIR to $DEST_DIR..."
cp -r $SOURCE_DIR/new_model_sweep.npz "$DEST_DIR/sweep.npz"


echo "Datasets copied from $SOURCE_DIR to $DEST_DIR"


# Creating temp file for evaluation
TEMP_CONFIG_FILE="GNN_model/data/model/dcrnn_WESCO_temp.yaml"
cp "GNN_model/data/model/dcrnn_WESCO.yaml" "$TEMP_CONFIG_FILE"

# Find latest epoch, change contents of temp file
LATEST_FILE=$(ls -v "${MODELS_FOLDER}"/epo*.tar | tail -n 1)
echo "Latest epoch found is: $LATEST_FILE"

EPOCH_TO_LOAD=$(echo "$LATEST_FILE" | grep -o -E '[0-9]+')
sed -i "s/epoch: [0-9]*/epoch: $EPOCH_TO_LOAD/" "$TEMP_CONFIG_FILE"

# Run evaluation
python GNN_model/save_predictions.py \
    --config_filename "${TEMP_CONFIG_FILE}" \
    --output_filename "${OUTPUT_FOLDER}/sweep_predictions.npz" | tee "${OUTPUT_FOLDER}/sweep_prediction_log.txt"

#rm "$TEMP_CONFIG_FILE"

echo "Pipeline completed"