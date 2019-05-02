
## TODO
 - Graphite Web is probably not working because static files are not being served. So maybe that's what Nginx was supposed to do... Take a look at it.
 - Carbon is complaining all the time that can't find "GRAPHITE_URL". I need a way to pass Graphite's URL to it. And that involves writing the URL to the `carbon.conf` (T.T) . These guys don't seem to like environment variables or CLI options.
