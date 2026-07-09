FROM kalilinux/kali-rolling:latest

# Install curated pentesting tools
RUN apt-get update && apt-get install -y \
    nmap \
    metasploit-framework \
    wireshark-common \
    dirb \
    nikto \
    gobuster \
    hydra \
    burpsuite \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Create non‑root user for safety
RUN useradd -m pentest && echo "pentest:pentest" | chpasswd && adduser pentest sudo

# Copy web dashboard and API code into the image
COPY dashboard /var/www/html
COPY api /opt/pentest_api

WORKDIR /opt/pentest_api

# Install Python dependencies
RUN pip3 install --no-cache-dir -r requirements.txt

EXPOSE 8080 8000

# Entrypoint script will start the API and static server
CMD ["/opt/pentest_api/entrypoint.sh"]
