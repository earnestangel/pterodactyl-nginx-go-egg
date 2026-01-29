# ── Base image ─────────────────────────────────────────────
FROM debian:bookworm-slim

LABEL author="EarnestAngel" maintainer="fareast.sn@gmail.com"

ENV DEBIAN_FRONTEND=noninteractive \
    GO_VERSION=1.22.5

# ── Install dependencies ──────────────────────────────────
RUN apt-get update && apt-get install -y \
        git \
        apt-transport-https \
        lsb-release \
        ca-certificates \
        wget \
        curl \
        nginx \
        unzip \
    \
    # ── Cloudflared (Multi-Arch) ──
    && ARCH=$(uname -m) \
    && if [ "$ARCH" = "x86_64" ]; then \
        wget -O /tmp/cloudflared.deb \
          https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb; \
    elif [ "$ARCH" = "aarch64" ]; then \
        wget -O /tmp/cloudflared.deb \
          https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm64.deb; \
    else \
        echo "Unsupported architecture: $ARCH" && exit 1; \
    fi \
    && dpkg -i /tmp/cloudflared.deb \
    && rm /tmp/cloudflared.deb \
    \
    # ── Install Go Lang (Multi-Arch) ──
    && if [ "$ARCH" = "x86_64" ]; then \
        GO_ARCH="amd64"; \
    elif [ "$ARCH" = "aarch64" ]; then \
        GO_ARCH="arm64"; \
    else \
        echo "Unsupported architecture: $ARCH" && exit 1; \
    fi \
    && wget -O /tmp/go.tar.gz \
        https://go.dev/dl/go${GO_VERSION}.linux-${GO_ARCH}.tar.gz \
    && rm -rf /usr/local/go \
    && tar -C /usr/local -xzf /tmp/go.tar.gz \
    && rm /tmp/go.tar.gz \
    \
    # Cleanup
    && rm -rf /var/lib/apt/lists/*

# ── Set Go Environment Variables ───────────────────────────
ENV PATH="/usr/local/go/bin:${PATH}" \
    GOPATH="/home/container/go" \
    GOCACHE="/home/container/.cache/go-build"

# ── Create non-root user ───────────────────────────────────
RUN useradd -m -d /home/container -s /bin/bash container \
    && echo "USER=container" >> /etc/environment \
    && echo "HOME=/home/container" >> /etc/environment \
    && mkdir -p /home/container/go \
    && chown -R container:container /home/container

WORKDIR /home/container

STOPSIGNAL SIGINT

# ── Copy entrypoint ────────────────────────────────────────
COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

CMD ["/entrypoint.sh"]
