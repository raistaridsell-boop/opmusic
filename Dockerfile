FROM python:3.10-slim-buster

ENV DEBIAN_FRONTEND=noninteractive

# ❌ Remove broken Yarn repository (GPG key error fix)
RUN rm -f /etc/apt/sources.list.d/yarn.list \
    && rm -f /etc/apt/sources.list.d/yarnpkg.list || true

# Use Debian archive (buster is old)
RUN sed -i 's|http://deb.debian.org/debian|http://archive.debian.org/debian|g' /etc/apt/sources.list \
    && sed -i '/security.debian.org/d' /etc/apt/sources.list

# Install system dependencies
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       ffmpeg \
       aria2 \
       git \
       curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy project files
COPY . .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Start bot
CMD ["python", "main.py"]
