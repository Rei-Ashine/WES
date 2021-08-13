#!/usr/bin/bash
#$ -S /usr/bin/bash

set -euo pipefail

echo
echo "========== Executing $(basename $0) =========="
cd $(dirname $0)

cd ..
source ./config

[ -f ${medium}/${sample_ids} ] && rm ${medium}/${sample_ids}

# EX_5429_*_1_1.fastq.gz
pattern="_1_1.fastq.gz"


echo -----
mkdir -p ${medium}
echo "Making Sample ID list  ..."
for filepath in `find ${INPUT} -name "*${pattern}" | sort -n `; do
    temp="$(basename $filepath)"
    id="${temp%*${pattern}}"
    echo "${id}" >> ${medium}/${sample_ids}
done
wait
echo "done!"
echo
