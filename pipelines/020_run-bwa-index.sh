#!/usr/bin/bash
#$ -S /usr/bin/bash
# Execution time for 020_run-bwa-index.sh : 0:59:29

set -euo pipefail

echo
echo "========== Executing $(basename $0) =========="
cd $(dirname $0)

cd ..
source ./config


START=$(date +%s)
echo -----
echo "Making indexes for Reference Sequences ..."
for bver in "${versions[@]}"; do
    echo "--------------- ${bver} ---------------"
    pushd ${refd}_${bver}
    refseq="${bver}.fasta"
    [ -e ${refseq} ] || abort "[Error] No such file: $(basename ${refseq})"

    if [ ${bver} = "hg19" ]; then
	bwa index ${refseq}
	wait
    fi
    if [ ${bver} = "hg38" ]; then
	abort "[Error] The script for ${bver} is not complete."
	wait
    fi
    ls -lh ${refseq}*
    popd
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
