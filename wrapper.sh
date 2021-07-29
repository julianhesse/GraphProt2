#!/bin/bash

# $1 positives file
# $2 negatives file
# $3 prediction file
# $4 output foulder

## Test
export PATH=/usr/local/cuda/bin:$PATH
echo $CPATH
echo $LD_LIBRARY_PATH
echo $DYLD_LIBRARY_PATH
python -c "import torch; print(torch.__version__)"
python -c "import torch; print(torch.cuda.is_available())"
python -c "import torch; print(torch.version.cuda)"
nvcc --version

## Training of network
#graphprot2 gt --in $1 --neg-in $2 --out $4/train_data
#graphprot2 train --in $4/train_data --out $4/trained_model

## Prediction of network
graphprot2 gp --in $3 --train-in $4/trained_model --out $4/prediction_data
graphprot2 predict --in $4/prediction_data --train-in $4/trained_model --out $4/prediction --mode 1
