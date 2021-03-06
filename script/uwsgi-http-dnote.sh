#! /bin/sh

/go-cron-linux -s "@daily" -p 0 -- /bin/sh -c '[ -n "`ls /dnote/db/*  2>/dev/null`" ] && find /dnote/db/* \( -iname "*" ! -iname "hashcash.db" \) -mtime +30 -exec rm {} \;' &

/usr/bin/generate_dnote_hashes

chown -R uwsgi:uwsgi /dnote

exec uwsgi \
  --uid uwsgi \
  --gid uwsgi \
  --plugin /usr/lib/uwsgi/python_plugin.so \
  --master \
  --processes ${PROCESSES} \
  --threads ${THREADS} \
  --http-socket :8080 \
  --manage-script-name \
  --chdir /usr/lib/python2.7/site-packages/dnote-1.0.1-py2.7.egg/dnote \
  --mount ${APPLICATION_ROOT}=__init__:DNOTE
