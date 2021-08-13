#!/usr/bin/bash
#$ -S /usr/bin/bash

set -euo pipefail

echo
echo "========== Executing $(basename $0) =========="
cd $(dirname $0)

cd ..
source ./config


echo -----
echo "Preparing ANNOVAR ..."
for bver in "${versions[@]}"; do
    echo "--------------- ${bver} ---------------"
    [ -d "${annovar}/humandb/${bver}_seq" ] || ${annovar}/annotate_variation.pl -buildver ${bver} -downdb seq ${annovar}/humandb/${bver}_seq
    [ -f "${annovar}/humandb/${bver}_refGene.txt" ] || ${annovar}/annotate_variation.pl -buildver ${bver} -downdb refGene -webfrom annovar ${annovar}/humandb/
    if [ ${bver} = "hg19" ]; then
	echo "Switching to UCSC/Ensembl Gene annotation ..."
	[ -f "${annovar}/humandb/${bver}_ensGene.txt" ] || ${annovar}/annotate_variation.pl -buildver ${bver} -downdb ensGene ${annovar}/humandb
	[ -f "${annovar}/humandb/${bver}_ensGeneMrna.fa" ] || ${annovar}/retrieve_seq_from_fasta.pl ${annovar}/humandb/${bver}_ensGene.txt -seqdir ${annovar}/humandb/${bver}_seq -format ensGene -outfile ${annovar}/humandb/${bver}_ensGeneMrn
	[ -f "${annovar}/humandb/${bver}_knownGene.txt" ] || ${annovar}/annotate_variation.pl -buildver ${bver} -downdb knownGene ${annovar}/humandb
	[ -f "${annovar}/humandb/${bver}_knownGeneMrna.fa" ] || ${annovar}/retrieve_seq_from_fasta.pl ${annovar}/humandb/${bver}_knownGene.txt -seqdir ${annovar}/humandb/${bver}_seq -format knownGene -outfile ${annovar}/humandb/${bver}_knownGeneMrna.fa
    fi
    if [ ${bver} = "hg38" ]; then
	echo "Switching to hg38 Ensembl Gene annotation ..."
	[ -f "${annovar}/humandb/${bver}_ensGene.txt" ] || ${annovar}/annotate_variation.pl -buildver ${bver} -downdb wgEncodeGencodeBasicV26 tem
	[ -f "${annovar}/humandb/${bver}_ensGeneMrna.fa" ] || ${annovar}/retrieve_seq_from_fasta.pl -format genericGene -seqfile ${annovar}/humandb/${bver}_seq/hg38.fa -outfile tempdir/${bver}_wgEncodeGencodeBasicV26Mrna.fa tempdir/${bver}_wgEncodeGencodeBasicV26
	[ -f "tempdir/${bver}_wgEncodeGencodeBasicV26.txt" ] && mv tempdir/${bver}_wgEncodeGencodeBasicV26.txt ${annovar}/humandb/${bver}_ensGene
	[ -f "tempdir/${bver}_wgEncodeGencodeBasicV26Mrna.fa" ] && mv tempdir/${bver}_wgEncodeGencodeBasicV26Mrna.fa ${annovar}/humandb/${bver}_ensGeneMrn
	[ -d "tempdir" ] && rm -r tempdir
    fi
done
wait
echo "done!"
echo
