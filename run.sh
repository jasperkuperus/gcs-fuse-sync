#!/bin/sh
gcsfuse --key-file ${KEY_FILE} ${GCS_BUCKET} /gcs-mount
unison -repeat watch -batch /gcs-mount /bucket-share
