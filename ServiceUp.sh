#!/bin/bash
/usr/lib/rstudio-server/bin/rserver --server-daemonize=0 --server-app-armor-enabled=0 &
jupyter notebook --no-browser --allow-root --ip=* --notebook-dir=/data --NotebookApp.password='sha1:6b9544c2c7e2:aad1bb43267946136db57f5857260d00416389ed'
