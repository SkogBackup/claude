# supabase self-hosted first boot

## what happened

Added the `supabase/supabase` repo to skogai-web for self-hosting. First attempt to `podman-compose up -d` failed with cascading dependency errors — `supabase-vector` couldn't start because `DOCKER_SOCKET_LOCATION` in `.env` pointed to `/var/run/docker.sock` (Docker default) instead of the rootless Podman socket at `/run/user/1000/podman/podman.sock`.

## rootless podman gotcha

The Supabase docker-compose has a `vector` service that mounts the container runtime socket for log collection. On rootless Podman:

1. The socket is at `/run/user/1000/podman/podman.sock`
2. `podman.socket` must be started manually: `systemctl --user start podman.socket`
3. `DOCKER_HOST` env var was set correctly but `DOCKER_SOCKET_LOCATION` in the compose `.env` was not

The cascading failure pattern: vector fails → analytics (depends on vector) fails → everything else (depends on analytics) fails. Only imgproxy (no dependencies) survived.

## fix

```
sed -i 's|DOCKER_SOCKET_LOCATION=/var/run/docker.sock|DOCKER_SOCKET_LOCATION=/run/user/1000/podman/podman.sock|' supabase/docker/.env
```

After fix, all 13 services came up healthy on first try.

## services running

imgproxy, vector, db, analytics, studio, kong (port 8000), auth, rest, realtime, meta, edge-functions, pooler, storage.
