#!/bin/bash

# Make sure 'wget' and 'unzip' is installed.
command -v wget >/dev/null 2>&1 || {
    echo "require 'wget' but it's not installed. Aborting." >&2; exit 1;
}
command -v unzip >/dev/null 2>&1 || {
    echo "require 'unzip' but it's not installed. Aborting." >&2; exit 1;
}

FILE=$1

if [ $FILE == "all" ]; then
    URL=https://www.dropbox.com/s/opskuf9wfewchdi/stats.zip?dl=0
    ZIP_FILE=./assets/stats2.zip
    wget -N $URL -O $ZIP_FILE
    unzip $ZIP_FILE -d ./assets
    rm $ZIP_FILE

    URL=https://www.dropbox.com/s/b59o5zf70xhy9dv/checkpoints.zip?dl=0
    ZIP_FILE=./checkpoints.zip
    wget -N $URL -O $ZIP_FILE
    unzip $ZIP_FILE -d .
    rm $ZIP_FILE

elif [ $FILE == "stats" ]; then
    URL=https://www.dropbox.com/s/opskuf9wfewchdi/stats.zip?dl=0
    ZIP_FILE=./assets/stats.zip
    wget -N $URL -O $ZIP_FILE
    unzip $ZIP_FILE -d ./assets
    rm $ZIP_FILE

elif [ $FILE == "checkpoints" ]; then
    URL=https://www.dropbox.com/s/b59o5zf70xhy9dv/checkpoints.zip?dl=0
    ZIP_FILE=./checkpoints.zip
    wget -N $URL -O $ZIP_FILE
    unzip $ZIP_FILE -d .
    rm $ZIP_FILE

elif  [ $FILE == "afhq-adain" ]; then
    URL=https://www.dropbox.com/s/4mx4v7iwrwt0873/afhq-adain.pt?dl=0
    mkdir -p ./checkpoints
    OUT_FILE=./checkpoints/afhq-adain.pt
    wget -N $URL -O $OUT_FILE
elif  [ $FILE == "afhq-stylegan2" ]; then
    URL=https://www.dropbox.com/s/uhn9go48aot4ohh/afhq-stylegan2-5M.pt?dl=0
    mkdir -p ./checkpoints
    OUT_FILE=./checkpoints/afhq-stylegan2-5M.pt
    wget -N $URL -O $OUT_FILE

elif  [ $FILE == "celebahq-adain" ]; then
    URL=https://www.dropbox.com/s/0wpdlhcnratmngg/celebahq-adain.pt?dl=0
    mkdir -p ./checkpoints
    OUT_FILE=./checkpoints/celebahq-adain.pt
    wget -N $URL -O $OUT_FILE
elif  [ $FILE == "celebahq-stylegan2" ]; then
    URL=https://www.dropbox.com/s/1z7w4hvz3zi8j9k/celebahq-stylegan2-5M.pt?dl=0
    mkdir -p ./checkpoints
    OUT_FILE=./checkpoints/celebahq-stylegan2-5M.pt
    wget -N $URL -O $OUT_FILE

elif  [ $FILE == "afhqv2" ]; then
    URL=https://www.dropbox.com/s/sm8wrqa6isjf904/afhqv2-512x512-5M.pt?dl=0
    mkdir -p ./checkpoints
    OUT_FILE=./checkpoints/afhqv2-512x512-5M.pt
    wget -N $URL -O $OUT_FILE

elif  [ $FILE == "church" ]; then
    URL=https://www.dropbox.com/s/fp5t8u4m5pz4cle/church-25M.pt?dl=0
    mkdir -p ./checkpoints
    OUT_FILE=./checkpoints/church-25M.pt
    wget -N $URL -O $OUT_FILE

elif  [ $FILE == "ffhq" ]; then
    URL=https://www.dropbox.com/s/b0rmvdlng754v10/ffhq-25M.pt?dl=0
    mkdir -p ./checkpoints
    OUT_FILE=./checkpoints/ffhq-25M.pt
    wget -N $URL -O $OUT_FILE

elif  [ $FILE == "flower" ]; then
    URL=https://www.dropbox.com/s/prm59lad28u66zg/flower-256x256-adain.pt?dl=0
    mkdir -p ./checkpoints
    OUT_FILE=./checkpoints/flower-256x256-adain.pt
    wget -N $URL -O $OUT_FILE

else
    echo "Unsupported arguments. Available arguments are:"
    echo "  all, stats, checkpoints,"
    echo "  afhq-adain, afhq-stylegan2, celebahq-adain, celebahq-stylegan2, afhqv2, church, ffhq, and flower"
    exit 1

fi