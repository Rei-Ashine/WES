#!/usr/bin/bash
#$ -S /usr/bin/bash
# Execution time for 011_remove-adapter.sh : 0:27:28 for sample001

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
mkdir -p ${medium}/trimmed
echo "Removing Illumina Universal Adapter ..."
find ${INPUT} -name "*.fastq.gz" -type f -print0 | sort -z | xargs -0 -n 2 -P ${NUM_PROCESS} \
    trim_galore -j ${NUM_CPU} -o ${medium}/trimmed --paired
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
