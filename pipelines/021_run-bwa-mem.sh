#!/usr/bin/bash
#$ -S /usr/bin/bash
# Execution time for 021_run-bwa-mem.sh : 2:18:47

set -euo pipefail

function abort
{
    echo "$@" 1>&2
    exit 1
}
export -f abort

function mapper()
{
    id="$1"
    ref="$2"
    threads="$3"
    source ./config
    rg="@RG\tID:${id}\tSM:${id}\tPL:illumina\tLB:${id}"
    #EX_5429_*_1_1_val_1.fq.gz
    F="${medium}/trimmed/${id}_1_1_val_1.fq.gz"
    #EX_5429_*_1_2_val_2.fq.gz
    R="${medium}/trimmed/${id}_1_2_val_2.fq.gz"

    [ -e ${F} ] || abort "[Error] No such file: $(basename ${F})"
    [ -e ${R} ] || abort "[Error] No such file: $(basename ${R})"
    [ -e ${ref} ] || abort "[Error] No such file: $(basename ${ref})"
    wait

    bwa mem -t ${threads} -R ${rg} ${ref} ${F} ${R} \
	| samtools view -@ ${threads} -b -1 - > ${medium}/mapped/${id}.bam
    wait
    echo -
    echo
}
export -f mapper

echo
echo "========== Executing $(basename $0) =========="
cd $(dirname $0)

cd ..
source ./config

NUM_PROCESS="5"
NUM_THREAD="5"


START=$(date +%s)
echo -----
mkdir -p ${medium}/mapped
echo "Mapping is in progress ..."
for bver in "${versions[@]}"; do
    echo "--------------- ${bver} ---------------"
    refseq="${refd}_${bver}/${bver}.fasta"

    if [ ${bver} = "hg19" ]; then
	cat ${medium}/${sample_ids} | xargs -d "\n" -P ${NUM_PROCESS} -I {} \
	    bash -c "mapper {} ${refseq} ${NUM_THREAD}"
	wait
    fi
    if [ ${bver} = "hg38" ]; then
	abort "[Error] The script for ${bver} is not complete."
	wait
    fi
done
ls -lh ${medium}/mapped/*.bam
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
