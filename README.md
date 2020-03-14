# gcs-fuse-sync

This docker image allows you to mount a Google Cloud Storage bucket and keep that in sync with a local directory. This directory is exposed as a volume, so that other containers within the same Kubernetes Pod can easily read and write to the bucket, using the sidecar as a proxy.

## Background

Google Cloud Storage buckets can not be easily mounted in Kubernetes Pods. There are some solutions floating around with [postStart and preStop hooks](https://github.com/maciekrb/gcs-fuse-sample). But before you can use that, you will need the [gcsfuse](https://cloud.google.com/storage/docs/gcs-fuse) installed in your container. If you want to mount a volume to a 3rd party container, this is not possible unless you're willing to create your own container.

A possible solution is to add a sidecar container to your Kubernetes Pod. Let that sidecar mount a volume using `gcsfuse` and expose that to the other container. This will however not work, as `gcsfuse` does not sync files, it merely mirrors local filesystem actions to API requests. So this only works in the container where you ran `gcsfuse`.

This image solves this solution by synchronising the mounted GCS bucket to a local folder (using [unison](https://www.cis.upenn.edu/~bcpierce/unison/index.html)) and exposing that folder as a volume. When you mount that folder in your other container, you can read and write to your bucket.

## Usage

### Simple Test

In order to do a quick check whether this works, you could do this:

```sh
docker run -it --privileged \
  -v /path/to/your/key.json:/vol/key.json \
  -e GCS_BUCKET=your-bucket-name \
  -e KEY_FILE=/vol/key.json \
  jasperkuperus/gcs-fuse-sync
```

The container is now running and actively keeping the bucket in sync with a local folder. You can connect with this container and play around to see the sync works:

```sh
docker ps
docker exec -it <container-id> /bin/sh
ls -al /gcs-mount
ls -al /bucket-share
echo wow > /bucket-share/hi.txt
cat /gcs-mount/hi.txt
```

The `gcs-mount` is the actual `gcsfuse` mount folder. This folder is synced with the normal folder `bucket-share`.

### Kubernetes

The usage of this image will only make sense when you add it to your Kubernetes setup. We'll create a Pod with 2 containers. One is our image that allows us to access our bucket. The other container is for this example a simple `nginxdemos/hello` container that will mount the `bucket-share` from the other container.

... WIP

## References

* [blue1st/docker-gcsfuse](https://github.com/blue1st/docker-gcsfuse)
* [GCS Fuse Example](https://github.com/maciekrb/gcs-fuse-sample)
* [gcsfuse](https://cloud.google.com/storage/docs/gcs-fuse)
* [unison](https://www.cis.upenn.edu/~bcpierce/unison/index.html)
