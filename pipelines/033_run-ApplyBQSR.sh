#!/usr/bin/bash
#$ -S /usr/bin/bash
# Execution time for 033_run-ApplyBQSR.sh : 0:43:45

set -euo pipefail

function abort
{
    echo "$@" 1>&2
    exit 1
}
export -f abort

function apply_bqsr()
{
    id="$1"
    ref="$2"
    source ./config
    # EX_5429_*.sort.dedup.bam
    bami="${medium}/dedup/${id}.sort.dedup.bam"
    recalibrated="${medium}/recal/${id}.sort.dedup.recal.bam"
    statistic="${medium}/recal/${id}.sort.dedup.recaltab.txt"

    [ -e ${ref} ] || abort "[Error] No such file: $(basename ${ref})"
    [ -e ${bami} ] || abort "[Error] No such file: $(basename ${bami})"
    [ -e ${statistic} ] || abort "[Error] No such file: $(basename ${statistic})"
    wait

    gatk ApplyBQSR --input ${bami} --output ${recalibrated} --reference ${ref} \
	--bqsr-recal-file ${statistic}
    wait
    echo -
    echo
}
export -f apply_bqsr

echo
echo "========== Executing $(basename $0) =========="
cd $(dirname $0)

cd ..
source ./config

NUM_PROCESS="5"


START=$(date +%s)
echo -----
echo "Recalibrating by applying the statistics to the actual data ..."
for bver in "${versions[@]}"; do
    echo "--------------- ${bver} ---------------"
    refseq="${refd}_${bver}/${bver}.fasta"

    if [ ${bver} = "hg19" ]; then
	cat ${medium}/${sample_ids} | xargs -d "\n" -P ${NUM_PROCESS} -I {} \
	    bash -c "apply_bqsr {} ${refseq}"
	wait
    fi
    if [ ${bver} = "hg38" ]; then
	abort "[Error] The script for ${bver} is not complete."
	wait
    fi
done
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
