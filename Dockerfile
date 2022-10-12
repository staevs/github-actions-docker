FROM ubuntu:22.04 AS setup

RUN useradd -m runner

ARG RUNNER_VERSION

RUN apt-get update -y && apt-get upgrade -y

RUN apt-get install --no-install-recommends -y sudo wget curl git jq ca-certificates gnupg lsb-release

RUN mkdir -p /etc/apt/keyrings
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
RUN apt-get update
RUN apt-get install --no-install-recommends -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

RUN rm -rf /var/lib/apt/lists/*
RUN rm -rf /tmp/*

RUN usermod -aG sudo runner
RUN usermod -aG docker runner
RUN echo '%sudo ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

WORKDIR /home/runner

RUN curl -O -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz
RUN tar xzf ./actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz
RUN ./bin/installdependencies.sh

COPY start.sh start.sh
RUN chmod +x start.sh

RUN rm -f actions.tar.gz

USER runner

ENTRYPOINT ["./start.sh"]
CMD ["./bin/Runner.Listener", "run", "--startuptype", "service"]
