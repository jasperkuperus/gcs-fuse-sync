#!/bin/sh
if [[ -z "${POLL_INTERVAL}" ]]
then
  POLL_INTERVAL=10
fi

gcsfuse --key-file ${KEY_FILE} ${GCS_BUCKET} /gcs-mount
unison -repeat $POLL_INTERVAL -batch /gcs-mount /bucket-share
