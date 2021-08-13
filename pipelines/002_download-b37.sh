#!/usr/bin/bash
#$ -S /usr/bin/bash
# Execution time for 002_download-b37.sh : 0:0:32

# The Broad Institute created a human genome reference file based on GRCh37.
# This reference is often referred to as b37 (Homo_sapiens_assembly19.fasta, MD5sum: 886ba1559393f75872c1cf459eb57f2d).
# When people at The Broad Institute's Genomics Platform refer to the hg19 reference, they are actually referring to b37.
# https://gatk.broadinstitute.org/hc/en-us/articles/360035890711-GRCh37-hg19-b37-humanG1Kv37-Human-Reference-Discrepancies#comparison

set -euo pipefail

echo
echo "========== Executing $(basename $0) =========="
cd $(dirname $0)

cd ..
source ./config


START=$(date +%s)
echo -----
echo "Downloading Reference Sequences from Broad Institute ..."
for bver in "${versions[@]}"; do
    echo "--------------- ${bver} ---------------"
    mkdir -p ${refd}_${bver}
    pushd ${refd}_${bver}

    # https://console.cloud.google.com/storage/browser/gcp-public-data--broad-references
    u1="https://storage.googleapis.com/gcp-public-data--broad-references"
    u2="${bver}/v0"

    if [ ${bver} = "hg19" ]; then
	b37_fasta="Homo_sapiens_assembly19.fasta"

	curl -sS -L -O ${u1}/${u2}/${b37_fasta} && mv ${b37_fasta} ${bver}.fasta
	wait
    fi
    if [ ${bver} = "hg38" ]; then
	abort "[Error] The script for ${bver} is not complete."
	wait
    fi
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
