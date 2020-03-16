#!/bin/sh
if [[ -z "${POLL_INTERVAL}" ]]
then
  POLL_INTERVAL=10
fi

gcsfuse --key-file ${KEY_FILE} ${GCS_BUCKET} /gcs-mount
unison -repeat $POLL_INTERVAL -prefer newer -batch -copyonconflict -dontchmod /gcs-mount /bucket-share
