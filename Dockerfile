FROM alpine:3.9

# Utilities we need in .gitlab-ci.yml for example
RUN apk --update add git bash openssh grep coreutils sed postgresql-client \
 && sed -i -e s:/bin/ash:/bin/bash:g /etc/passwd

RUN echo "===> Installing sudo to emulate normal OS behavior..."  && \
    apk --update add sudo                                         && \
    \
    echo "===> Adding Python runtime..."  && \
    apk --update add python py-pip openssl ca-certificates    && \
    apk --update add py2-dnspython                            && \
    apk --update add --virtual build-dependencies \
                python-dev libffi-dev openssl-dev build-base  && \
    pip install --upgrade pip cffi                            && \
    \
    echo "===> Installing Ansible..."  && \
    pip install ansible                && \
    \
    echo "===> Removing package list..."  && \
    apk del build-dependencies            && \
    rm -rf /var/cache/apk/*               && \
    \
    echo "===> Adding hosts for convenience..."  && \
    mkdir -p /etc/ansible                        && \
    echo 'localhost' > /etc/ansible/hosts

COPY ansible-playbook-wrapper /usr/local/bin/

# install docker client and compose
RUN apk --update add curl openrc docker \
 && rc-update add docker boot \
 && pip install docker-compose

#RUN apk --update add curl && \
#    curl -L https://github.com/docker/machine/releases/download/v0.12.2/docker-machine-`uname -s`-`uname -m` >/tmp/docker-machine && \
#    chmod +x /tmp/docker-machine && \
#    mv -f /tmp/docker-machine /usr/local/bin/docker-machine

WORKDIR /root

# install scripts
ENV BUILD_DATE 20180427001
RUN pip install requests
RUN git clone https://github.com/raarts/gitlab-ci-utils.git \
 && cd gitlab-ci-utils \
 && ./install \
 && cd .. \
 && rm -rf gitlab-ci-utils

# install ansible roles
RUN ansible-galaxy install -p /etc/ansible/roles git+https://github.com/raarts/stack-deploy

CMD ["/bin/bash"]
