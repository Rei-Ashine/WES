#!/usr/bin/bash
#$ -S /usr/bin/bash
# Execution time for 010_check-quality.sh : 0:25:59

set -euo pipefail

function abort
{
    echo "$@" 1>&2
    exit 1
}
export -f abort

function check_quality()
{
    id="$1"
    threads="$2"
    source ./config
    # EX_5429_*_1_1.fastq.gz
    F="${INPUT}/${id}_1_1.fastq.gz"
    # EX_5429_*_1_2.fastq.gz
    R="${INPUT}/${id}_1_2.fastq.gz"

    [ -e ${F} ] || abort "[Error] No such file: $(basename ${F})"
    [ -e ${R} ] || abort "[Error] No such file: $(basename ${R})"
    wait

    fastqc --nogroup -q -t ${threads} -o ${OUTPUT}/Pre-alignmentQC ${F}
    fastqc --nogroup -q -t ${threads} -o ${OUTPUT}/Pre-alignmentQC ${R}
    wait
    echo -
    echo
}
export -f check_quality

echo
echo "========== Executing $(basename $0) =========="
cd $(dirname $0)

cd ..
source ./config

NUM_PROCESS="5"
NUM_THREAD="5"


START=$(date +%s)
echo -----
mkdir -p ${OUTPUT}/Pre-alignmentQC
echo "Checking the Quality of fastq not-trimmed ..."
cat ${medium}/${sample_ids} | xargs -d "\n" -P ${NUM_PROCESS} -I {} \
    bash -c "check_quality {} ${NUM_THREAD}"
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
