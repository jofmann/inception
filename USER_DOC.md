# User Documentation

## What Services Are Running

This project runs three core services and one bonus service, all inside Docker containers:

**Nginx** is the entry point for all web traffic. It handles HTTPS on port 443 and forwards requests to WordPress. You cannot access WordPress directly — all traffic goes through Nginx.

**WordPress** is the website and content management system. It runs PHP in the background and handles all page generation. You can create posts, manage users, install plugins, and configure the site through its admin panel.

**MariaDB** is the database. It stores all WordPress content — posts, pages, users, settings. It runs silently in the background and is not directly accessible from outside the network.

**FTP server (vsftpd)** provides direct file access to the WordPress installation. You can use it to upload themes, plugins, or images directly to the server without going through the WordPress admin panel.

---

## Starting and Stopping the Project

**Start everything:**
```bash
make
```

This will automatically generate all passwords and the SSL certificate if they do not exist yet, then build and start all containers in the background.

**Stop all containers without losing data:**
```bash
make down
```

**Stop without removing containers:**
```bash
make stop
```

**Delete all data and start fresh:**
```bash
make fclean
make
```

> ⚠️ `make fclean` deletes all database and WordPress data permanently.

---

## Accessing the Website

Open your browser and go to:

| Page | URL |
|------|-----|
| Website | `https://<DOMAIN_NAME>` |
| Admin panel | `https://<DOMAIN_NAME>/wp-admin` |

Your browser will show a security warning because the SSL certificate is self-signed. This is expected — click "Advanced" and proceed to the site.

---

## Accessing the Admin Panel

Go to `https://<DOMAIN_NAME>/wp-admin` and log in with the WordPress admin credentials.

To find your admin username and password, see the [Credentials](#credentials) section below.

From the admin panel you can:
- Write and publish posts and pages
- Install and manage plugins and themes
- Create and manage users
- Configure site settings

---

## Credentials

All passwords are stored as plain text files in the `secrets/` directory at the root of the repository. They are generated automatically the first time you run `make`.

| File | What it contains |
|------|-----------------|
| `secrets/mysql_user_pw.txt` | MariaDB user password |
| `secrets/mysql_root_pw.txt` | MariaDB root password |
| `secrets/wp_admin_pw.txt` | WordPress admin password |
| `secrets/wp_user_pw.txt` | WordPress regular user password |
| `secrets/ftp_password.txt` | FTP user password |

To read a password:
```bash
cat secrets/wp_admin_pw.txt
```

The WordPress admin username is defined in `srcs/.env` as `WORDPRESS_ADMIN_USER`.
The FTP username is defined in `srcs/.env` as `FTP_USER`.

> ⚠️ Never commit the `secrets/` directory to Git. It is listed in `.gitignore`.

---

## FTP Access

You can connect to the FTP server to upload or download files directly to the WordPress installation (e.g. themes, plugins, images).

**Connect from the terminal:**
```bash
ftp <DOMAIN_NAME>
# Username: <value of FTP_USER in srcs/.env>
# Password: <contents of secrets/ftp_password.txt>
```

**Connect with FileZilla:**
- Host: `<DOMAIN_NAME>`
- Username: value of `FTP_USER` in `srcs/.env`
- Password: contents of `secrets/ftp_password.txt`
- Port: `21`
- Protocol: FTP (not SFTP)

Once connected you will land in `/var/www/html` — the root of the WordPress installation. You can navigate to `wp-content/uploads` to upload images or `wp-content/themes` to upload a theme manually.

---

## Checking That Services Are Running

**See all running containers:**
```bash
docker ps
```

All four containers should show status `Up`. The MariaDB container also shows its health status — it should read `healthy`.

**Check logs for a specific service:**
```bash
docker logs nginx-container
docker logs wordpress-container
docker logs maria-container
docker logs ftp-container
```

**Follow logs in real time:**
```bash
docker logs -f wordpress-container
```

**Check MariaDB health specifically:**
```bash
docker inspect --format='{{.State.Health.Status}}' maria-container
# Should output: healthy
```

If a container shows `Restarting` in `docker ps`, check its logs to find the error.