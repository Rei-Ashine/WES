#!/usr/bin/bash
#$ -S /usr/bin/bash

set -euo pipefail

function abort
{
    echo "$@" 1>&2
    exit 1
}

echo
echo "========== Executing $(basename $0) =========="
cd $(dirname $0)

cd ..
source ./config

[ -d "${annovar}" ] && abort "Annovar is already installed."
[ $# = 0 ] && abort "[Error] No arguments: Enter the annovar.*.tar.gz file path"
[ -f $1 ] || abort "[Error] No such file: $(basename $1)"


echo -----
echo "Installing Annovar ..."
tar zxvf $1
wait

suffix=__TEMP__
mkdir -p ${annovar}${suffix}
mv ./annovar/* ${annovar}${suffix}/
rm -r ./annovar
mv ${annovar}${suffix} ${annovar}
wait

${annovar}/annotate_variation.pl
