*This project has been created as part of the 42 curriculum by [phhofman].*

# Inception

## Description

Inception is a system administration project from the 42 curriculum. The goal is to set up a small infrastructure composed of different services running inside Docker containers, orchestrated with Docker Compose. All containers are built from scratch using custom Dockerfiles based on Debian Bookworm or Alpine — no pre-built images from Docker Hub are allowed.

The infrastructure consists of three core services:

- **Nginx** — acts as the sole entry point, handling HTTPS on port 443 with TLS 1.2/1.3 and forwarding PHP requests to WordPress via FastCGI
- **WordPress + PHP-FPM** — the content management system, running without a web server of its own
- **MariaDB** — the relational database storing all WordPress data

As a bonus, an **FTP server** (vsftpd) is included, providing direct file access to the WordPress volume.

All services communicate over a dedicated Docker bridge network. Persistent data is stored in named volumes mounted to `/home/login/data/` on the host.

### Design Choices

**Virtual Machines vs Docker**

Virtual machines emulate complete hardware and run a full OS kernel, making them heavy and slow to start. Docker containers share the host kernel and only bundle what the application needs — making them lightweight, fast, and portable. However, VMs provide stronger isolation since each has its own kernel. For this project, Docker is the right choice because the goal is service isolation and reproducibility, not full OS-level separation.

**Secrets vs Environment Variables**

Environment variables are simple to use but insecure — they are visible in plain text via `docker inspect` and stored in the container configuration on disk. Docker Secrets are mounted as `tmpfs` inside the container at `/run/secrets/`, meaning they never touch the disk and are not visible via `docker inspect`. In this project, sensitive values such as database passwords are stored as Docker Secrets, while non-sensitive configuration like domain names and usernames are stored in a `.env` file.

**Docker Network vs Host Network**

With `--network host`, a container shares the host's network interface directly — no isolation, no internal DNS, and potential port conflicts. A Docker bridge network creates a virtual isolated network where containers communicate using their container names as hostnames, resolved by Docker's internal DNS. In this project, all containers are connected to a custom bridge network called `inception-net`. Only Nginx exposes a port to the outside world (443). MariaDB and WordPress are completely unreachable from outside the network.

**Docker Volumes vs Bind Mounts**

Bind mounts link a specific host path directly into the container — simple but fragile, as they depend on the host's directory structure. Named volumes are managed by Docker and are more portable, but by default their location on the host is opaque. This project uses a hybrid approach: named volumes with `driver_opts` pointing to specific host paths under `/home/login/data/`. This satisfies the project requirement of using named volumes while keeping data at a predictable location on the host.

---

## Instructions

### Requirements

- Docker and Docker Compose installed on a Debian-based system
- `make` installed
- A user with sudo privileges

### Setup

**1. Clone the repository:**
```bash
git clone <repository-url>
cd inception
```

**2. Create the `.env` file** based on the provided example:
```bash
cp srcs/.env.example srcs/.env
# Edit srcs/.env with your values
```

**3. Add your domain to `/etc/hosts`:**
```bash
echo "127.0.0.1 login.42.fr" | sudo tee -a /etc/hosts
```

**4. Build and start the infrastructure:**
```bash
make
```

The `secrets/` directory, all passwords, and the SSL certificate are generated automatically by `make`. No manual setup required.

### Makefile Targets

| Target | Description |
|--------|-------------|
| `make` / `make up` | Generate secrets, build images and start all containers in the background |
| `make build` | Build all Docker images without starting containers |
| `make down` | Stop and remove all containers and the network |
| `make clean` | Stop containers and clear volume data |
| `make fclean` | Full cleanup — removes containers, images, and volume data |
| `make re` | Full rebuild from scratch |

### Accessing the Services

| Service | URL / Address |
|---------|--------------|
| WordPress | `https://login.42.fr` |
| WordPress Admin | `https://login.42.fr/wp-admin` |
| FTP | `ftp login.42.fr` (port 21) |

---

## Resources

### Docker & Infrastructure

- [Docker Official Documentation](https://docs.docker.com/)
- [Docker Compose Reference](https://docs.docker.com/compose/compose-file/)
- [Dockerfile Best Practices](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)
- [Docker Networking Overview](https://docs.docker.com/network/)
- [Docker Secrets](https://docs.docker.com/engine/swarm/secrets/)

### Services

- [Nginx Documentation](https://nginx.org/en/docs/)
- [PHP-FPM Configuration](https://www.php.net/manual/en/install.fpm.configuration.php)
- [MariaDB Documentation](https://mariadb.com/kb/en/documentation/)
- [WordPress WP-CLI](https://wp-cli.org/)
- [vsftpd Manual](https://security.appspot.com/vsftpd.html)

### TLS & Security

- [OpenSSL Documentation](https://www.openssl.org/docs/)
- [TLS 1.2 vs TLS 1.3](https://www.cloudflare.com/learning/ssl/why-use-tls-1.3/)

### AI Usage

- **Understanding concepts** — Docker networking, layers, volumes, PID 1, FastCGI, and the relationship between Nginx and PHP-FPM were explained interactively
- **Debugging** — error messages from container logs were analyzed together to identify root causes
- **Configuration** — vsftpd, Nginx, and MariaDB configuration files were written and reviewed with AI assistance
- **Code review** — init scripts and Dockerfiles were reviewed for correctness and security
- **Comparisons** — VM vs Docker, Secrets vs env vars, and other architectural decisions were discussed to inform design choices

All code was understood, reviewed, and adapted manually — AI was used as a tutor and rubber duck, not as a code generator.