#!/usr/bin/env bash

set -e

OUTDIR=${1-/logs}
SALTDIR=${SALTDIR-/srv/salt}

find ${OUTDIR} -name "*.code" -o  -name "*.err" -o -name "*.out" | xargs rm -f
sls_files=($(cd ${SALTDIR} && find -L -name '*.sls'))
for sls_file in "${sls_files[@]}"
do
    truncated=${sls_file#./}
    truncated=${truncated%.sls}
    dotted=$(echo $truncated | sed 's,/,.,g')
    echo "Checking sls:" $dotted
    salt-call -lwarning $SALTOPTS state.show_sls "${dotted}" > "${OUTDIR}/${dotted}.out" 2> "${OUTDIR}/${dotted}.err"
    echo -n $? > "${OUTDIR}/${dotted}.code"
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

if ! grep -v 0 ${OUTDIR}/*.code
then
    if [[ -z $(cat ${OUTDIR}/*.err) ]]
    then
        for outfile in ${OUTDIR}/*.out
        do
            check_stdout $outfile
        done
        echo Ok
        exit 0
    fi
fi
echo Fail
exit 1
