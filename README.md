# gcs-fuse-sync

This docker image allows you to mount a Google Cloud Storage bucket and keep that in sync with a local directory. This directory is exposed as a volume, so that other containers within the same Kubernetes Pod can easily read and write to the bucket, using the sidecar as a proxy.

## Background

Google Cloud Storage buckets can not be easily mounted in Kubernetes Pods. There are some solutions floating around with [postStart and preStop hooks](https://github.com/maciekrb/gcs-fuse-sample). But before you can use that, you will need the [gcsfuse](https://cloud.google.com/storage/docs/gcs-fuse) installed in your container. If you want to mount a volume to a 3rd party container, this is not possible unless you're willing to create your own container.

A possible solution is to add a sidecar container to your Kubernetes Pod. Let that sidecar mount a volume using `gcsfuse` and expose that to the other container. This will however not work, as `gcsfuse` does not sync files, it merely mirrors local filesystem actions to API requests. So this only works in the container where you ran `gcsfuse`.

This image solves this solution by synchronising the mounted GCS bucket to a local folder (using [unison](https://www.cis.upenn.edu/~bcpierce/unison/index.html)) and exposing that folder as a volume. When you mount that folder in your other container, you can read and write to your bucket.

## Usage

... WIP
