#!/usr/bin/bash
#$ -S /usr/bin/bash
# Execution time for 031_prep-RefSeq-index.sh : 0:0:28

set -euo pipefail

echo
echo "========== Executing $(basename $0) =========="
cd $(dirname $0)

cd ..
source ./config


START=$(date +%s)
echo -----
echo "Preparing an index file for the Reference Genome Sequence ..."
for bver in "${versions[@]}"; do
    echo "--------------- ${bver} ---------------"
    refseq="${refd}_${bver}/${bver}.fasta"
    dict="${refd}_${bver}/${bver}.dict"

    [ -e ${refseq} ] || abort "[Error] No such file: $(basename ${refseq})"

    picard CreateSequenceDictionary -REFERENCE ${refseq} -OUTPUT ${dict}
    samtools faidx ${refseq}
    wait
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
