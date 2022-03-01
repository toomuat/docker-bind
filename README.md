# BIND 9 DNS server in Docker container

```
git clone https://github.com/toomuat/docker-bind
cd docker-bind
docker build -t test_bind .
docker run \
    --rm \
    -p 53:53/udp \
    --name test_bind_container \
    test_bind
```



```
$ dig @localhost localhost
```

