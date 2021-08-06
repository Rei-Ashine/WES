#!/usr/bin/bash
#$ -S /usr/bin/bash
# Execution time for 010_check-quality.sh : 0:5:57 for sample001

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
mkdir -p ${OUTPUT}/Pre-alignmentQC
echo "Checking the quality of fastq not-trimmed ..."
find ${INPUT} -name "*.fastq.gz" -type f -print0 | sort -z | xargs -0 -n 1 -P ${NUM_PROCESS} \
    fastqc --nogroup -q -t ${NUM_CPU} -o ${OUTPUT}/Pre-alignmentQC
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
