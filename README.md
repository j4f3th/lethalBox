
# LethalBox

Dispotable Docker enviroment to practice web programming and scripting with nvim without dirtying your local host.

## What's Inside

- Debian
- PHP, Python3, Node.js, Bash (with `shellcheck` and `shfmt`)
- Non-root user with passwordless `sudo`
- Port `8081` published **only to your host's loopback** (`127.0.0.1`)


## Dependencies

- **Docker**: https://docs.docker.com/engine/install/
- **Docker compose**: https://docs.docker.com/compose/install/

## Install

```bash
git clone --depth 1 https://github.com/j4f3th/lethalBox
cd lethalBox
chmod +x *.sh
./startup.sh
```

The first build will always take a while, If the script fails will show you last lines of a log.

## Run

```bash
./run.sh
```

This will open a shell inside of the container. Your working directory is `~/workspace`, this one is mapped on your local host (`./lethalBox/docker/workspace`)

## Usage / Examples

Inside the container:

```shell
nvim index.php 
php -S 0.0.0.0:8081
```

Then open http://127.0.0.1:8081 in your local host.

Other examples:


```bash
python3 -m http.server 8081 --bind 0.0.0.0
node server.js
bash script.sh
```

### About the port


The container must listen on `0.0.0.0:8081`, if it listens on `127.0.0.1` or any other port, it won't be reachable by the local host.

```
container 0.0.0.0:8081  ->  host 127.0.0.1:8081
```

## Cleanup

To stop and delete everything (container, image, volumes and `docker/workspace`):

```bash
./cleanup.sh
````

## Notes

- NvChad icons need a [Nerd Font](https://www.nerdfonts.com/) set in your host terminal.
- Neovim plugins are stored in Docker volumes, so they survive rebuilds. `./cleanup.sh` removes them too.
