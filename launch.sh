#!/bin/bash

RPC_USER="${RPC_USER:-user}"
RPC_PASS="${RPC_PASS:-pass}"
RPC_PORT="${RPC_PORT:-8332}"
RPC_HOST="${RPC_HOST:-localhost}"
MQ_PORT="${MQ_PORT:-29000}"

CFG_FILE=$HOME/blockchaincfg.json

sed -i 's/@RPC_USER@/'"$RPC_USER"'/' $CFG_FILE
sed -i 's/@RPC_PASS@/'"$RPC_PASS"'/' $CFG_FILE
sed -i 's/@RPC_HOST@/'"$RPC_HOST"'/g' $CFG_FILE
sed -i 's/@RPC_PORT@/'"$RPC_PORT"'/' $CFG_FILE
sed -i 's/@MQ_PORT@/'"$MQ_PORT"'/' $CFG_FILE

cd $GOPATH/src/blockbook && exec ./blockbook -sync -blockchaincfg=$HOME/blockchaincfg.json -internal=:9099 -public=:9199 -certfile=server/testcert -log_dir=/opt/coins/blockbook/log
