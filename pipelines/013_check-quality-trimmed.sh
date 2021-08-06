#!/usr/bin/bash
#$ -S /usr/bin/bash
# Execution time for 013_check-quality-trimmed.sh : 0:5:25 for sample001

set -euo pipefail

echo
echo "========== Executing $(basename $0) =========="
cd $(dirname $0)

cd ..
source ./config

NUM_PROCESS="4"
NUM_CPU="2"


START=$(date +%s)
echo -----
mkdir -p ${OUTPUT}/fastQC_trimmed
echo "Checking the quality of fastq trimmed ..."
find ${medium}/trimmed -name "*_val_*.fq.gz" -type f -print0 | xargs -0 -n 1 -P ${NUM_PROCESS} \
    fastqc --nogroup -q -t ${NUM_CPU} -o ${OUTPUT}/fastQC_trimmed
wait
echo "done!"
echo


END=$(date +%s)
echo -----
PT=$(( ${END} - ${START} ))
H=$(( ${PT} / 3600 ))
PT=$(( ${PT} % 3600 ))
M=$(( ${PT} / 60 ))
S=$(( ${PT} % 60 ))
echo "Execution time for $(basename $0) : ${H}:${M}:${S}"
wait
echo
