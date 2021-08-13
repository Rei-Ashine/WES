#!/usr/bin/bash
#$ -S /usr/bin/bash
# Execution time for 030_download-GATK-Bundles.sh : 0:0:38

set -euo pipefail

echo
echo "========== Executing $(basename $0) =========="
cd $(dirname $0)

cd ..
source ./config


START=$(date +%s)
echo -----
echo "Downloading GATK Bundles ..."
for bver in "${versions[@]}"; do
    echo "--------------- ${bver} ---------------"
    mkdir -p ${gatkb}_${bver}
    pushd ${gatkb}_${bver}

    # https://console.cloud.google.com/storage/browser/gcp-public-data--broad-references
    # Ref: https://gatk.broadinstitute.org/hc/en-us/articles/360035890811-Resource-bundle
    u1="https://storage.googleapis.com/gcp-public-data--broad-references"
    u2="${bver}/v0"

    if [ ${bver} = "hg19" ]; then
	dbsnp="dbsnp_138.b37.vcf.gz"
	dbsnp_tbi="dbsnp_138.b37.vcf.gz.tbi"
	mills="Mills_and_1000G_gold_standard.indels.b37.vcf.gz"
	mills_tbi="Mills_and_1000G_gold_standard.indels.b37.vcf.gz.tbi"

	curl -sS -L -O ${u1}/${u2}/${dbsnp} &
	curl -sS -L -O ${u1}/${u2}/${dbsnp_tbi} &
	curl -sS -L -O ${u1}/${u2}/${mills} &
	curl -sS -L -O ${u1}/${u2}/${mills_tbi} &
	wait
    fi
    if [ ${bver} = "hg38" ]; then
	abort "[Error] The script for ${bver} is not complete."

	dbsnp="Homo_sapiens_assembly38.dbsnp138.vcf.gz"
	dbsnp_tbi="Homo_sapiens_assembly38.dbsnp138.vcf.gz.tbi"
	mills="Mills_and_1000G_gold_standard.indels.hg38.vcf.gz"
	mills_tbi="Mills_and_1000G_gold_standard.indels.hg38.vcf.gz.tbi"

	curl -sS -L -O ${u1}/${u2}/${dbsnp} &
	curl -sS -L -O ${u1}/${u2}/${dbsnp_tbi} &
	curl -sS -L -O ${u1}/${u2}/${mills} &
	curl -sS -L -O ${u1}/${u2}/${mills_tbi} &
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
