#!/usr/bin/bash
#$ -S /usr/bin/bash
# Execution time for 032_run-BaseRecalibrator.sh : 1:17:1

set -euo pipefail

function abort
{
    echo "$@" 1>&2
    exit 1
}
export -f abort

function recalibrator()
{
    id="$1"
    ref="$2"
    known1="$3"
    known2="$4"
    source ./config
    # EX_5429_*.sort.dedup.bam
    bami="${medium}/dedup/${id}.sort.dedup.bam"
    statistic="${medium}/recal/${id}.sort.dedup.recaltab.txt"

    [ -e ${ref} ] || abort "[Error] No such file: $(basename ${ref})"
    [ -e ${bami} ] || abort "[Error] No such file: $(basename ${bami})"
    [ -e ${known1} ] || abort "[Error] No such file: $(basename ${known1})"
    [ -e ${known2} ] || abort "[Error] No such file: $(basename ${known2})"
    wait

    gatk BaseRecalibrator --input ${bami} --output ${statistic} --reference ${ref} \
	--known-sites ${known1} --known-sites ${known2}
    wait
    echo -
    echo
}
export -f recalibrator

echo
echo "========== Executing $(basename $0) =========="
cd $(dirname $0)

cd ..
source ./config

NUM_PROCESS="5"


START=$(date +%s)
echo -----
mkdir -p ${medium}/recal
echo "Obtaining Statistics for Recalibration ..."
for bver in "${versions[@]}"; do
    echo "--------------- ${bver} ---------------"
    refseq="${refd}_${bver}/${bver}.fasta"

    if [ ${bver} = "hg19" ]; then
	dbsnp="${gatkb}_${bver}/dbsnp_138.b37.vcf.gz"
	mills="${gatkb}_${bver}/Mills_and_1000G_gold_standard.indels.b37.vcf.gz"

	cat ${medium}/${sample_ids} | xargs -d "\n" -P ${NUM_PROCESS} -I {} \
	    bash -c "recalibrator {} ${refseq} ${dbsnp} ${mills}"
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
