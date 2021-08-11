#!/usr/bin/bash
#$ -S /usr/bin/bash

set -euo pipefail

echo
echo "========== Executing $(basename $0) =========="
cd $(dirname $0)

cd ..
source ./config


echo -----
echo "Downloading Reference Sequences ..."
for bver in "${versions[@]}"; do
    echo "--------------- ${bver} ---------------"
    mkdir -p ${refd}_${bver}
    pushd ${refd}_${bver}

    if [ ${bver} = "hg19" ]; then
	# http://hgdownload.cse.ucsc.edu/goldenpath/hg19/bigZips/analysisSet/hg19.p13.plusMT.no_alt_analysis_set.fa.gz
	# http://hgdownload.cse.ucsc.edu/goldenpath/hg19/bigZips/analysisSet/hg19.p13.plusMT.no_alt_analysis_set.bwa_index.tar.gz
	u1="ftp://hgdownload.cse.ucsc.edu"
	u2="goldenPath/${bver}/bigZips/analysisSet"
	u3="${bver}.p13.plusMT.no_alt_analysis_set.fa.gz"
	idx="${bver}.p13.plusMT.no_alt_analysis_set"
	extension=".bwa_index.tar.gz"
	suffix=__TEMP__
	filename=${bver}.fasta

	curl -sS ${u1}/${u2}/${u3} -o ${u3}${suffix} \
	    && mv ${u3}${suffix} ${u3}
	mv ${u3} ${filename}.gz
	gunzip ${filename}.gz

	curl -sS ${u1}/${u2}/${idx}${extension} -o ${idx}${extension}${suffix} \
	    && mv ${idx}${extension}${suffix} ${idx}${extension}
	tar zxvf ${idx}${extension} && rm ${idx}${extension}
	rename ${idx}.fa ${filename} ${idx}/${idx}.fa.*
	mv ${idx}/* ./ && rm -r ${idx}
    fi
    if [ ${bver} = "hg38" ]; then
	abort "[Error] The script for ${bver} is not complete."
	# https://hgdownload.cse.ucsc.edu/goldenpath/hg38/bigZips/analysisSet/hg38.analysisSet.chroms.tar.gz
	u1="ftp://hgdownload.soe.ucsc.edu"
	u2="goldenPath/${bver}/bigZips/analysisSet"
	u3="${bver}.analysisSet.chroms.tar.gz"
	suffix=__TEMP__

	curl ${u1}/${u2}/${u3} -o ${u3}${suffix} \
	    && mv ${u3}${suffix} ${u3}
	tar zxvf ${u3}
    fi
    popd
done
wait
echo "done!"
echo
