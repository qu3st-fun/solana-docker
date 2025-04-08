# 📦 Solana Development Docker Scaffold

This repository provides a minimal Docker-based setup for Solana + Anchor development, based on `ubuntu:latest` (24.04) and using the latest tooling. It’s meant to be forked and used as a base to start new Solana projects.

---

## 🚀 Quick Start

### 1. Clone this repo (or fork it) and enter the directory

```bash
git clone https://github.com/mischa-robots/solana-docker.git
cd solana-docker
```

### 2. Build the Docker image

```bash
docker compose build
```

### 3. Start a development container

```bash
docker compose up
```

This will start the Solana docker development container.

Now you can access it with:

```
docker compose exec -it solana-dev bash
```

and use the commands `solana`, `anchor`, `node` etc inside it.


---

## Make helper commands

The Makefile contains some helper commands to access the docker container:

`make solana command` -> Runs 'solana <command>' inside the container

`make anchor command` -> Runs 'anchor <command>' inside the container

`make node command` -> Runs 'node <command>' inside the container (using bash -ic)

`make npm command` -> Runs 'npm <command>' inside the container (using bash -ic)

`make bash` -> Opens an interactive shell in the container

`make help` -> show help


If you want to pass arguments with `--` like `node --version` , Make interprets “--version” as a flag for itself (and prints its version) rather than passing it on to the node target.

To forward such flags to your node (or any other program) inside the container, you need to separate Make’s options from the target’s arguments using a double dash (--) before. For example:

```bash
make node -- --version`
```


---

## Solana key pair

The `.config/solana` directory is mounted as `solana`, so if you have already a key (`id.json` file) you can simply add it there.

Otherwise create one by:

```bash
# on your host:

make bash

# then inside the container:

solana-keygen new
```

The key is then persisted to your host, so it will be not deletet when you remove the container.

Though it will be ignored by git, so you cannot accidentely push it to github.


## 🛠 Creating a New Project

Inside the running container shell:

```bash
anchor init myproj
cd myproj
anchor build
```

Your project will be created under the `workspace/` directory and will persist on your host machine.

The `workspace/` folder is mounted into the container and all files created there will match your local user permissions.

You can then commit and push the contents of `workspace/myproj/` as your own Solana project to your own repository.

This repository will ignore everything inside the workspace directory, but `anchor init` will also init a new git repo inside it.

It is also possible to create multiple projects within the workspace each as its own repo.

---

## 🧹 Cleanup

To remove the container after you're done:

```bash
docker compose down
```

Your project will stay on your host in the `workspace/` directory, so you can build and run a fresh container.

Also the `id.json` will stay in the solana directory, if you created one.

---

## 📦 Tool installed in the image

- based on Ubuntu 24.04
- Rust via rustup (latest)
- Solana CLI (latest)
- Anchor CLI (latest)
- Node.js + yarn (latest)

## Anchor docs

Check out the [anchor docs](https://www.anchor-lang.com/docs/).
