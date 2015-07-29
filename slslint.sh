#!/usr/bin/env bash

set -e

outdir=${1-/logs}

find ${outdir} -name "*.code" -o  -name "*.err" -o -name "*.out" | xargs rm -f
sls_files=($(cd /srv/salt && find -name '*.sls'))
for sls_file in "${sls_files[@]}"
do
    truncated=${sls_file#./}
    truncated=${truncated%.sls}
    dotted=$(echo $truncated | sed 's,/,.,g')
    echo "Checking sls:" $dotted
    salt-call -lwarning state.show_sls "${dotted}" > "${outdir}/${dotted}.out" 2> "${outdir}/${dotted}.err"
    echo -n $? > "${outdir}/${dotted}.code"
done

if ! grep -v 0 ${outdir}/*.code
then
    if [[ -z $(cat ${outdir}/*.err) ]]
    then
        echo Ok
        exit 0
    fi
fi
echo Fail
exit 1
