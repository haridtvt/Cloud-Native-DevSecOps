# stage 1: build stage
FROM ubuntu:22.04 AS builder
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y python3 python3-pip libmysqlclient-dev gcc

WORKDIR /opt/build

COPY shop-app/requirements.txt .

RUN pip3 install --user -r requirements.txt

# stage 2: Runtime stage
FROM ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y python3 libmysqlclient21 && \
    rm -rf /var/lib/apt/lists/*

RUN useradd -m hari

USER hari

WORKDIR /opt/app

COPY --from=builder /root/.local /home/hari/.local

COPY shop-app/ .

ENV PATH=/home/hari/.local/bin:$PATH

EXPOSE 5000

CMD ["python3", "app.py"]