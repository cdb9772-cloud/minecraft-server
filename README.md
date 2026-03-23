# Minecraft Docker Server

A dockerized Minecraft server with a CI/CD pipeline that automatically builds and deploys to a DigitalOcean droplet on every push to main.

## How it works

When you push to main, GitHub Actions:
1. Downloads the latest Minecraft server jar
2. Builds a Docker image around it
3. Saves the image as a tar and SCPs it to the server
4. SSH's in and restarts the container with the new image

No manual deployment needed.

## Requirements

- Docker installed on the host machine
- A `.env` file in the root of the project (see below)

## Setup

### Environment Variables

Create a `.env` file in the project root:

```
DOCKERDATA=/path/to/store/world/data
PORT=25565
SERVER_NAME=your-server-name
```

- `DOCKERDATA` — where world data, configs, and whitelists get stored on the host
- `PORT` — port to expose the server on
- `SERVER_NAME` — used to namespace multiple servers under the same host

### Build Manually

```bash
./build.sh
```

This downloads the latest Minecraft server jar, sets up the directory structure, and builds the Docker image.

### Run

```bash
docker-compose up -d
```

## CI/CD Pipeline

The pipeline lives in `.github/workflows/deploy.yml` and runs on every push to main.

### Required GitHub Secrets

| Secret | Value |
|---|---|
| `SERVER_IP` | IP of your deployment server |
| `SERVER_USER` | SSH username |
| `SSH_PASSWORD` | SSH password |

### What gets deployed

Files copied to the server on each deploy:
- `docker-compose.yml`
- `.env`
- `minecraft.tar` (the built image)

The deploy step then loads the image and restarts the container.

## Live Server

Accessible at `159.203.125.129:25565` in Minecraft.

World data persists across deployments via Docker volume mounts on the host machine.

## Useful Commands

Check the container is running:
```bash
docker ps
```

View server logs:
```bash
docker logs $(docker ps -q) --tail 50
```

Stop the server:
```bash
docker stop $(docker ps -q)
```

## License

[The Unlicense](https://unlicense.org)