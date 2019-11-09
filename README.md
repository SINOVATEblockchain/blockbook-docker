# Blockbook Docker

Docker container for Blockbook, the Trezor wallet backend.

Build image

```
docker build -t sinteam/blockbook .
```

Build Container

```
docker create --name blockbook -it --network="host" -e RPC_USER=rpc -e RPC_PASS=pass -e RPC_HOST=127.0.0.1 -e MQ_PORT=29000 sinteam/blockbook
```

It will start syncing and the progress can be checked at https://localhost:9199

In your Trezor wallet, go to "Wallet Settings" and in the "Bitcore Server URL" put the URL above.


## Stopping gracefully

Start
```docker start blockbook```

To stop the container gracefully (and have the database files preserved), do a ```docker stop -t 60 blockbook``` and to restart it later.
