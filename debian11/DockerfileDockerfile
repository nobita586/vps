FROM debian:11
ENV RAM=2048
ENV CPU=2
ENV DISK_SIZE=50G
RUN mkdir -p /vmdata
WORKDIR /vmdata
RUN apt-get update && apt-get install -y openssh-server sudo vim curl && rm -rf /var/lib/apt/lists/*
RUN echo "root:root" | chpasswd
EXPOSE 22
CMD ["/usr/sbin/sshd","-D"]
