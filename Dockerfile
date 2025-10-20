FROM ruby:3.2-slim

# Install dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Install the wayback_machine_downloader gem
RUN gem install wayback_machine_downloader

# Create a working directory for downloads
WORKDIR /downloads

# Set the entrypoint to the wayback_machine_downloader command
ENTRYPOINT ["wayback_machine_downloader"]

# Default command shows help
CMD ["--help"]
