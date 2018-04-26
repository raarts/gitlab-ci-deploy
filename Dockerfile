FROM golang:1.10-alpine
MAINTAINER Ron Arts <ron.arts@gmail.com>

RUN echo "===> Installing sudo to emulate normal OS behavior..."  && \
    apk --update add sudo                                         && \
    \
    \
    echo "===> Adding Python runtime..."  && \
    apk --update add python py-pip openssl ca-certificates    && \
    apk --update add --virtual build-dependencies \
                python-dev libffi-dev openssl-dev build-base  && \
    pip install --upgrade pip cffi                            && \
    \
    \
    echo "===> Installing Ansible..."  && \
    pip install ansible                && \
    \
    \
    echo "===> Removing package list..."  && \
    apk del build-dependencies            && \
    rm -rf /var/cache/apk/*               && \
    \
    \
    echo "===> Adding hosts for convenience..."  && \
    mkdir -p /etc/ansible                        && \
    echo 'localhost' > /etc/ansible/hosts


COPY ansible-playbook-wrapper /usr/local/bin/

# install docker client
RUN apk --update add curl && \
    curl -L https://github.com/docker/machine/releases/download/v0.12.2/docker-machine-`uname -s`-`uname -m` >/tmp/docker-machine && \
    chmod +x /tmp/docker-machine && \
    mv -f /tmp/docker-machine /usr/local/bin/docker-machine

# install terraform
RUN apk --update add git bash openssh

ENV TERRAFORM_VERSION=0.11.7
ENV TF_DEV=true
ENV TF_RELEASE=true

WORKDIR $GOPATH/src/github.com/hashicorp/terraform
RUN git clone https://github.com/hashicorp/terraform.git ./ \
 && git checkout v${TERRAFORM_VERSION} \
 && /bin/bash scripts/build.sh \
 && mv pkg/linux_amd64/terraform /usr/local/bin \
 && mkdir -p ~/.terraform.d/plugins \
 && terraform version

# install provider drivers
RUN apk --update add make

# Hetzner cloud
WORKDIR $GOPATH/src/github.com/hetznercloud/terraform-provider-hcloud
RUN git clone https://github.com/hetznercloud/terraform-provider-hcloud ./ \
 && make build \
 && mv $GOPATH/bin/terraform-provider-hcloud  ~/.terraform.d/plugins/terraform-provider-hcloud_v1.2.0 \
 && cd \
 && rm -rf $GOPATH/src/github.com/hetznercloud/terraform-provider-hcloud

# Vultr
WORKDIR $GOPATH/src/github.com/squat/terraform-provider-vultr
RUN git clone https://github.com/squat/terraform-provider-vultr ./ \
 && make \
 && mv $GOPATH/bin/terraform-provider-vultr  ~/.terraform.d/plugins/terraform-provider-vultr_v1.0.0 \
 && cd \
 && rm -rf $GOPATH/src/github.com/squat/terraform-provider-vultr

# Linode
WORKDIR $GOPATH/src/github.com/LinodeContent/terraform-provider-linode
RUN go get -u golang.org/x/crypto/sha3
RUN go get -u github.com/taoh/linodego
RUN git clone https://github.com/LinodeContent/terraform-provider-linode ./ \
 && cd bin/terraform-provider-linode \
 && go build -o terraform-provider-linode \
 && mv terraform-provider-linode  ~/.terraform.d/plugins/terraform-provider-linode_v1.0.0 \
 && cd \
 && rm -rf $GOPATH/src/github.com/squat/terraform-provider-linode

# ProxMox
WORKDIR $GOPATH/src/github.com/raarts/terraform-provider-proxmox
RUN go get -u github.com/Telmate/proxmox-api-go
RUN git clone https://github.com/raarts/terraform-provider-proxmox.git ./ \
 && git checkout remote-api-changes \
 && sed -i -e 's/Telmate/raarts/g' main.go \
 && go build -o terraform-provider-proxmox \
 && cp terraform-provider-proxmox  ~/.terraform.d/plugins/terraform-provider-proxmox_v0.1.0 \
 && cd \
 && rm -rf $GOPATH/src/github.com/raarts/terraform-provider-proxmox

# No longer need the source trees
# RUN rm -rf $GOPATH/src/* 

WORKDIR /root

ADD provider.tf .
RUN terraform init

# default command: display Ansible version
CMD [ "ansible-playbook", "--version" ]

