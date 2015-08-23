#!/usr/bin/env bash

set -e

OUTDIR=${1-/logs}

find ${OUTDIR} -name "*.code" -o  -name "*.err" -o -name "*.out" | xargs rm -f
states=($(salt-call $SALTOPTS cp.list_states | awk '{print $2}' | grep -v '^top' | grep -v '^$' | sort))
for state in "${states[@]}"
do
    echo "Checking sls:" $state
    salt-call -lwarning $SALTOPTS state.show_sls "${state}" > "${OUTDIR}/${state}.out" 2> "${OUTDIR}/${state}.err"
    echo -n $? > "${OUTDIR}/${state}.code"
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

if ! grep -E '[^0]' ${OUTDIR}/*.code
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
