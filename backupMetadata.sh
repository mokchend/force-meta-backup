#!/bin/bash

# To be run inside the Docker container
alias=$1

mkdir -p /data01/force-meta-backup/${alias}

rsync -av --progress /workspace/force-meta-backup/* /data01/force-meta-backup/${alias} --exclude .git
#cp -Rp /workspace/force-meta-backup/* /data01/force-meta-backup/${alias}

cp /workspace/config/build.${alias}.properties /data01/force-meta-backup/${alias}/build.properties

mydate=$(date '+%Y-%m-%d_%H_%M_%S')
cd /data01/force-meta-backup/${alias}/
time ant backupMetadata > /data01/force-meta-backup/${alias}/backupMetadata_${mydate}.log