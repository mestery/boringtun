# Using this with Docker

To run this stuff with Docker:

```
docker-compose build
docker-compse run -d
```

Then you will have two containers, wireguard1 and wireguard2.

You can login to wireguard1 and ping wireguard2 over the tunnel:

```
docker exec -it wireguard1 bash
ping -c 5 192.168.2.3
```

The packets will go into the wg0 interface, boringtun will encrypt them,
and then the encrypted UDP packets are sent out eth0 on wireguad1 to
wireguard2. The return path follows the same.
