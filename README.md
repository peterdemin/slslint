# Check your .sls files are syntactically correct

Script `slslint.sh` ensures .sls files are syntactically correct by following scenario:

1. find all `.sls` files in `/srv/salt/` directory;
2. execute `salt-call state.show_sls` for each one;
3. Store execution results in `logs` directory;
4. Check all log files for errors.

Checked conditions for each `.sls`:

1. Exit code equals 0;
2. stderr is empty;
3. stdout does not contain error report;

# Docker

If you are familiar with [Docker](https://www.docker.com/),
you can find files in `example` directory useful for building linting container.
