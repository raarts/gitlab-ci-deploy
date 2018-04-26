FROM alpine:3.7

RUN apk --update add git bash openssh

RUN echo "===> Installing sudo to emulate normal OS behavior..."  && \
    apk --update add sudo                                         && \
    \
    echo "===> Adding Python runtime..."  && \
    apk --update add python py-pip openssl ca-certificates    && \
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

# install docker client
RUN apk --update add curl docker

WORKDIR /root

# install scripts
RUN pip install requests
RUN git clone https://github.com/raarts/gitlab-ci-utils.git \
 && cd gitlab-ci-utils \
 && ./install \
 && cd .. \
 && rm -rf gitlab-ci-utils

# default command: display Ansible version
CMD [ "ansible-playbook", "--version" ]

