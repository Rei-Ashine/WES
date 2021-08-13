#!/usr/bin/bash
#$ -S /usr/bin/bash
# Execution time for 012_check-quality-trimmed.sh : 0:23:56

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
    # EX_5429_*_1_1_val_1.fq.gz
    F="${medium}/trimmed/${id}_1_1_val_1.fq.gz"
    # EX_5429_*_1_2_val_2.fq.gz
    R="${medium}/trimmed/${id}_1_2_val_2.fq.gz"

    [ -e ${F} ] || abort "[Error] No such file: $(basename ${F})"
    [ -e ${R} ] || abort "[Error] No such file: $(basename ${R})"
    wait

    fastqc --nogroup -q -t ${threads} -o ${OUTPUT}/Post-trimQC ${F}
    fastqc --nogroup -q -t ${threads} -o ${OUTPUT}/Post-trimQC ${R}
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
mkdir -p ${OUTPUT}/Post-trimQC
echo "Checking the Quality of fastq trimmed ..."
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
