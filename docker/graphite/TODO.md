
## TODO
 - [x] Graphite Web is probably not working because static files are not being served. So maybe that's what Nginx was supposed to do... Take a look at it.
 - [x] Carbon is complaining all the time that can't find "GRAPHITE_URL". I need a way to pass Graphite's URL to it. And that involves writing the URL to the `carbon.conf`. (I disabled tagging, not gonna used it anyway)
 - [x] `/opt/graphite/conf/storage-aggregation.conf not found or wrong perms, ignoring.`
 - [x] Serve Django's admin static files. First gotta figure out how to use the admin. (`django-admin.py collectstatic --noinput --settings=graphite.settings` will generate static files on `/opt/graphite/static`, all of them, including for the admin.)
 - [ ] Maybe use PosgreSQL? I used to get a lot of error messages from SQLite on Graphite's web app, but since I built this new stack, things seem to be working normally. I feel like SQLite should be enough: http://obfuscurity.com/2013/12/Why-You-Shouldnt-use-SQLite-with-Graphite.
 - [ ] Create `/opt/graphite/webapp/graphite/local_settings.py`. Need to adjust the TIME_ZONE. I don't care for the SECRET_KEY for now (https://stackoverflow.com/a/16630719/4630320).
 - [ ] Where are the logs being written to? Are they really getting "rotated"? I'm not worried about keeping logs, I just don't want them to take much space.
