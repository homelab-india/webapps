To create initial configuration file run: 
```
docker run -it --rm \
    --mount type=volume,src=synapse-data,dst=/data \
    -e SYNAPSE_SERVER_NAME=my.matrix.host \
    -e SYNAPSE_REPORT_STATS=yes \
    matrixdotorg/synapse:latest generate
```
Go to the default location top copy all the files in your local directory from where you will be drploying matrix. Default path (after going root)
```
cd /var/lib/docker/volumes/synapse-data/_data
```
Copy all the files. Then change permissions to your local user. While in the directory in which the files are there after copying
```
chown user:group *
```
Configure and run docker compose
