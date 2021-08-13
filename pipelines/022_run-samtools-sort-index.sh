#!/usr/bin/bash
#$ -S /usr/bin/bash
# Execution time for 022_run-samtools-sort-index.sh : 0:5:58

set -euo pipefail

function abort
{
    echo "$@" 1>&2
    exit 1
}
export -f abort

function sorter()
{
    id="$1"
    threads="$2"
    memory="2G"
    source ./config
    # EX_5429_*.bam
    bami="${medium}/mapped/${id}.bam"
    sorted="${medium}/sorted/${id}.sort.bam"

    [ -e ${bami} ] || abort "[Error] No such file: $(basename ${bami})"
    wait

    samtools sort -@ ${threads} -m ${memory} ${bami} > ${sorted}
    samtools index -@ ${threads} ${sorted}
    wait
    echo -
    echo
}
export -f sorter

echo
echo "========== Executing $(basename $0) =========="
cd $(dirname $0)

cd ..
source ./config

NUM_PROCESS="5"
NUM_THREAD="5"


START=$(date +%s)
echo -----
mkdir -p ${medium}/sorted
echo "Sorting is in progress ..."
for bver in "${versions[@]}"; do
    echo "--------------- ${bver} ---------------"

    if [ ${bver} = "hg19" ]; then
	cat ${medium}/${sample_ids} | xargs -d "\n" -P ${NUM_PROCESS} -I {} \
	    bash -c "sorter {} ${NUM_THREAD}"
	wait
    fi
    if [ ${bver} = "hg38" ]; then
	abort "[Error] The script for ${bver} is not complete."
	wait
    fi
done
ls -lh ${medium}/sorted/*.sort.bam*
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
