
Assuming Grafana's container name is "grafana", you can copy the `grafana.ini` config file into the container with:
```
docker cp grafana.ini grafana:/etc/grafana/grafana.ini
docker restart grafana # For changes to take effect.
```
