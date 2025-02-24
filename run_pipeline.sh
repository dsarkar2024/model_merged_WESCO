#!/bin/bash


SOURCE_DIR="data_WESCO/cache"
DEST_DIR="GNN_model/data/WESCO"
MODELS_FOLDER="models"
OUTPUT_FOLDER="outputs"

mkdir -p "$DEST_DIR"
mkdir -p "$MODELS_FOLDER"
mkdir -p "$OUTPUT_FOLDER"

rm -rf "$DEST_DIR"/*

echo "Copying Adjacency Matrix from $SOURCE_DIR to $DEST_DIR..."
cp -r "$SOURCE_DIR/adj_mx.pkl" "$DEST_DIR"

echo "Copying datasets from $SOURCE_DIR to $DEST_DIR..."
cp -r $SOURCE_DIR/new_model_train.npz "$DEST_DIR"
cp -r $SOURCE_DIR/new_model_val.npz "$DEST_DIR"
cp -r $SOURCE_DIR/new_model_test.npz "$DEST_DIR"

echo "Datasets copied from $SOURCE_DIR to $DEST_DIR"


# Training
echo "Training DCRNN model:"
python3 GNN_model/dcrnn_train_pytorch.py \
    --config_filename "GNN_model/data/model/dcrnn_WESCO.yaml"
echo "Training completed"

# Creating temp file for evaluation
#TEMP_CONFIG_FILE="GNN_model/data/model/$MODEL_EVAL/dcrnn_WESCO_${sensor}_temp.yaml"
#cp "GNN_model/data/model/$MODEL_EVAL/dcrnn_WESCO_$sensor.yaml" "$TEMP_CONFIG_FILE"

# Find latest epoch, change contents of temp file
#LATEST_FILE=$(ls -v "${MODELS_FOLDER}"/epo*.tar | tail -n 1)
#echo "Latest epoch found is: $LATEST_FILE"

#EPOCH_TO_LOAD=$(echo "$LATEST_FILE" | grep -o -E '[0-9]+')
#sed -i "s/epoch: [0-9]*/epoch: $EPOCH_TO_LOAD/" "$TEMP_CONFIG_FILE"

# Run evaluation
#python GNN_model/save_predictions.py \
    #--config_filename "GNN_model/data/model/$MODEL_EVAL/dcrnn_WESCO_${sensor}_PREDS.yaml" \
    #--output_filename "${OUTPUT_FOLDER}/${sensor}_predictions.npz" | tee "${OUTPUT_FOLDER}/${sensor}_log.txt"

#rm "$TEMP_CONFIG_FILE"

# Copy best weights into the output folder
#cp "${LATEST_FILE}" "${OUTPUT_FOLDER}/${sensor}_weights.tar"
#echo "Copied ${LATEST_FILE} into ${OUTPUT_FOLDER}/"

# # # Clear the epochs folder
#rm -f "${MODELS_FOLDER}"/*.tar
#echo "Cleared epochs of ${MODELS_FOLDER}/"


#echo "Pipeline completed"