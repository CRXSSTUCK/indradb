#!/bin/bash

set -e

export TEST_RDB_DIRECTORY=`mktemp -d 2>/dev/null || mktemp -d -t 'indradb'`
export RUST_BACKTRACE=1
export TEST_POSTGRES_URL="postgres://postgres@localhost:5432/indradb_test"

ACTION=test

while true; do
    case "$1" in
        --bench) ACTION=bench; shift ;;
        * ) break ;;
    esac
done

function cleanup {
    echo "Cleaning up..."
    rm -r $TEST_RDB_DIRECTORY
    docker-compose stop
}

mkdir -p $TEST_RDB_DIRECTORY
docker-compose up -d
trap cleanup EXIT

dropdb -U postgres -h localhost --if-exists indradb_test
createdb -U postgres -h localhost --owner=postgres indradb_test
cargo $ACTION --all-features $TEST_NAME
