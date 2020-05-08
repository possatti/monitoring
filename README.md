
My stack for watching system resources from multiple computers on the web.

The stack:
 - Collectd - Collects CPU, memory usage, and a bunch of other things using a modular plugin design.
 - Graphite - Stores numeric time-series data and render ~~ugly~~ graphs from it.
 - Grafana - Gathers time-series from multiple sources (e.g., graphite) and render beautiful graphs and dashboards.

## Collectd

I usually install Collectd from `apt` like `sudo apt-get install collectd`. Then I configure it through the file `/etc/collectd/collectd.conf` (the file usually has a lot of comments explaining things). Restart the service (`sudo systemctl restart collectd.service` when using systemd). And that's it. Super easy.

## Watching NVIDIA GPUs

For some time I used [nvidia2graphite](https://github.com/stefan-k/nvidia2graphite). It worked reasonably well, but I [forked it](https://github.com/possatti/nvidia2graphite), so that I could make some changes of my own, like: fixed power readings; fixed crashing when graphite is not already up; enabled restarting of the service.

There is an official C plugin for Collectd, but it doesn't come with apt's package yet, and it is very limited on what you can get.

A also made a Python plugin that integrates well with Collectd: [nvsmi](https://github.com/possatti/collectd-nvidia-smi/). It reads the output of `nvidia-smi` at each reading cycle. I took care to make it as efficient as possible.

## Graphite

To get graphite running quickly, you can use the [official graphite docker image](https://github.com/graphite-project/docker-graphite-statsd).

In a small setup, I think I would prefer to run it without Nginx. I don't use StatsD at all and neither Carbon Aggregator. The image also has collectd on in but it's disabled by default, which I prefer.

```bash
docker run -d\
 --name graphite\
 --restart=always\
 -p 2003-2004:2003-2004\
 -p 8080:8080\
 --env CARBON_AGGREGATOR_DISABLED=1\
 --env STATSD_DISABLED=1\
 --env NGINX_DISABLED=1\
 graphiteapp/graphite-statsd
```

This works most of the time, but I've had problems with it a couple of times. I've had some issue with Carbon stopping to listen and not getting back even with a restart. I still couldn't debug and get around this issue.

## Grafana

It's super easy to get [Grafana working with Docker](https://grafana.com/docs/installation/docker/), and it worked really well for me.

```bash
docker run -d --name grafana --restart=always -p 3000:3000 grafana/grafana
```

Once it's running, you can log in and setup things like: the graphite source, users, and the dashboards. Maybe a persistent volume would be a good idea, I'll take a look at this later.
