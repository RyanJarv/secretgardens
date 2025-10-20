FROM ruby:3.2-slim

# Install dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    git \
    && rm -rf /var/lib/apt/lists/*

# Install the patched wayback_machine_downloader gem from StrawberryMaster fork
RUN mkdir /tmp/wayback && git clone https://github.com/StrawberryMaster/wayback-machine-downloader.git /tmp/wayback && \
    cd /tmp/wayback && \
    sed -i 's/3\.4\.3/3.2.0/' wayback_machine_downloader.gemspec && \
    gem build wayback_machine_downloader.gemspec && \
    gem install wayback_machine_downloader_straw-*.gem && \
    rm -rf /tmp/wayback

# Create a working directory for downloads
WORKDIR /downloads

# Set the entrypoint to the wayback_machine_downloader command
ENTRYPOINT ["wayback_machine_downloader"]

# Default command shows help
CMD ["--help"]
