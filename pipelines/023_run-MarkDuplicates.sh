#!/usr/bin/bash
#$ -S /usr/bin/bash
# Execution time for 023_run-MarkDuplicates.sh : 0:58:0

set -euo pipefail

function abort
{
    echo "$@" 1>&2
    exit 1
}
export -f abort

function deduplicates()
{
    id="$1"
    source ./config
    # EX_5429_*.sort.bam
    bami="${medium}/sorted/${id}.sort.bam"
    deduped="${medium}/dedup/${id}.sort.dedup.bam"
    metrix="${medium}/dedup/${id}.sort.dedup.metrix.txt"

    [ -e ${bami} ] || abort "[Error] No such file: $(basename ${bami})"
    wait

    picard MarkDuplicates -INPUT ${bami} -OUTPUT ${deduped} -METRICS_FILE ${metrix} \
	-VALIDATION_STRINGENCY LENIENT -REMOVE_DUPLICATES true
    wait
    echo -
    echo
}
export -f deduplicates 

echo
echo "========== Executing $(basename $0) =========="
cd $(dirname $0)

cd ..
source ./config

NUM_PROCESS="5"


START=$(date +%s)
echo -----
mkdir -p ${medium}/dedup
echo "Marking duplicates ..."
for bver in "${versions[@]}"; do
    echo "--------------- ${bver} ---------------"

    if [ ${bver} = "hg19" ]; then
	cat ${medium}/${sample_ids} | xargs -d "\n" -P ${NUM_PROCESS} -I {} \
	    bash -c "deduplicates {}"
	wait
    fi
    if [ ${bver} = "hg38" ]; then
	abort "[Error] The script for ${bver} is not complete."
	wait
    fi
done
ls -lh ${medium}/dedup/*.sort.dedup.bam
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
