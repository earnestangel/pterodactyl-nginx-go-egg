# Pterodactyl Nginx + Go Egg

A Pterodactyl Egg specifically designed to run Nginx with Go Lang support. Autoupdate is removed for now. This is a WIP,
some functionality may be missing, and is not expected to be run in production environments. 

Originally forked from [Ym0T/pterodactyl-nginx-egg](https://github.com/Ym0T/pterodactyl-nginx-egg)

## Nginx Reverse Proxy to Go Lang
Example Nginx configuration to reverse proxy to a Go Lang application running on the same server.

```nginx
location / {
    proxy_pass http://localhost:8125; # Replace with your Go Lang app's address and port
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
}
```

Add this configuration in `/home/container/nginx/conf.d/default.conf`, inside the `server` block.

## Docker Image
https://hub.docker.com/r/ririkoai/pterodactyl-nginx-go/tags

## License

[MIT License](https://choosealicense.com/licenses/mit/)

Forked and adapted from: https://github.com/Ym0T/pterodactyl-nginx-egg and https://gitlab.com/tenten8401/pterodactyl-nginx