FROM python:3.12-slim
RUN apt-get update && apt-get install -y --no-install-recommends ffmpeg fonts-dejavu-core curl ca-certificates \
    && rm -rf /var/lib/apt/lists/*
# Cloudflare WARP (bepul): YouTube Render IP'sini bloklasa zaxira yo'l sifatida ishlatiladi
RUN curl -fsSL -o /usr/local/bin/wgcf https://github.com/ViRb3/wgcf/releases/download/v2.3.1/wgcf_2.3.1_linux_amd64 \
    && chmod +x /usr/local/bin/wgcf \
    && curl -fsSL https://github.com/windtf/wireproxy/releases/download/v1.1.3/wireproxy_linux_amd64.tar.gz \
       | tar xz -C /usr/local/bin wireproxy
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY bot.py .
RUN cp /usr/share/fonts/truetype/dejavu/DejaVuSans.ttf /usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf /app/
# YouTube tez-tez o'zgaradi: har ishga tushganda yt-dlp ni yangilaymiz
CMD ["sh", "-c", "pip install -U -q 'yt-dlp[default]' ; python bot.py"]
