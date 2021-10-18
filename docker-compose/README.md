# CoSMoS Docker Compose Deployment

## Prerequisite

- [docker](https://docs.docker.com/get-docker/)
- [npm](https://docs.npmjs.com/downloading-and-installing-node-js-and-npm)

## Quick Start

1. Update environment variables in `docker-compose.yaml` and `build.sh`
2. Run `build.sh` to build the frontend components
3. Run `docker compose up` to run all the components

```bash
nano dockercompose.yaml  # Update variables
nano build.sh            # Update variables
./build.sh
docker compose up
```

## Environment variables reference

### ummc-backend

#### auth-enabled

todo
