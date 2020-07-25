#!/bin/bash

# To be run inside the Docker container
alias=$1

DATA01_PATH=/data01/force-meta-backup

mkdir -p ${DATA01_PATH}/${alias}

rsync -av --progress /workspace/force-meta-backup/* ${DATA01_PATH}/${alias} --exclude .git
#cp -Rp /workspace/force-meta-backup/* ${DATA01_PATH}/${alias}

cp /workspace/config/build.${alias}.properties ${DATA01_PATH}/${alias}/build.properties

mydate=$(date '+%Y-%m-%d_%H_%M_%S')
cd ${DATA01_PATH}/${alias}/
time ant backupMetadata 2>&1 > ${DATA01_PATH}/${alias}/backupMetadata_${mydate}.log

cp -Rp ${DATA01_PATH}/${alias}/build/metadata/ ${DATA01_PATH}/${alias}/src/  2>&1 >> ${DATA01_PATH}/${alias}/backupMetadata_${mydate}.log

cd ${DATA01_PATH}/${alias}/src/

if [ -d .git ]; then
    echo "*** Initialize a local git repository"  2>&1 >> ${DATA01_PATH}/${alias}/backupMetadata_${mydate}.log
    git init . 2>&1 >> ${DATA01_PATH}/${alias}/backupMetadata_${mydate}.log
    git add .  2>&1 >> ${DATA01_PATH}/${alias}/backupMetadata_${mydate}.log
    git add commit -am "Init via automation" 2>&1 >> ${DATA01_PATH}/${alias}/backupMetadata_${mydate}.log
else
    echo "*** Update via automation" 2>&1 >> ${DATA01_PATH}/${alias}/backupMetadata_${mydate}.log
    git add . 2>&1 >> ${DATA01_PATH}/${alias}/backupMetadata_${mydate}.log
    git add commit -am "Updated via automation" 2>&1 >> ${DATA01_PATH}/${alias}/backupMetadata_${mydate}.log
fi;

