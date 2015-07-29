slslint.sh finds all .sls files in /srv/salt/ and executes salt-call state.show_sls for each one.

There are also some scripts for launching this check inside Docker container.
Build docker image like written in build.sh
Launch docker container like written in run.sh
