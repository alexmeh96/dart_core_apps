```shell
curl --request GET --url 'http://localhost:9999'
```

```shell
telnet localhost 9999
```

```shell
websocat ws://localhost:9999/ws -t
```
```shell
websocat ws://localhost:9999/ws -b
```
```shell
websocat ws://localhost:9999/ws -1 -t - <<< "hello"
```
