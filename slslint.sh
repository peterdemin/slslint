#!/usr/bin/env bash

set -e

outdir=${1-/logs}

find ${outdir} -name "*.code" -o  -name "*.err" -o -name "*.out" | xargs rm -f
sls_files=($(cd /srv/salt && find -L -name '*.sls'))
for sls_file in "${sls_files[@]}"
do
    truncated=${sls_file#./}
    truncated=${truncated%.sls}
    dotted=$(echo $truncated | sed 's,/,.,g')
    echo "Checking sls:" $dotted
    salt-call -lwarning state.show_sls "${dotted}" > "${outdir}/${dotted}.out" 2> "${outdir}/${dotted}.err"
    echo -n $? > "${outdir}/${dotted}.code"
done

function check_stdout() {
    if [ $(wc -l $1 | awk '{print $1}') -eq 2 ]
    then
        if [ "$(tail -n 1 $1)" != "    ----------" ]
        then
            echo Fail
            exit 2
        fi
    fi
}

if ! grep -v 0 ${outdir}/*.code
then
    if [[ -z $(cat ${outdir}/*.err) ]]
    then
        for outfile in ${outdir}/*.out
        do
            check_stdout $outfile
        done
        echo Ok
        exit 0
    fi
fi
echo Fail
exit 1
