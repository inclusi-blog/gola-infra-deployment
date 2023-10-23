FROM openjdk:12-alpine

RUN apk --no-cache add --update bash=4.4.19-r1

RUN apk upgrade openssl

RUN apk add git

RUN apk add gettext
# Install required dependencies
RUN apk --no-cache add \
    python3 \
    py3-pip

# Install the AWS CLI using pip
RUN pip3 install --upgrade awscli

ENV FLYWAY_VERSION 9.22.0
ENV USERNAME gola
ENV HOME /home/$USERNAME
ENV WORKDIR /home/$USERNAME
ENV UID 553
ENV GID 994

RUN addgroup -g $GID $USERNAME && \
    adduser -u $UID -G $USERNAME -s /bin/sh -h $HOME -D $USERNAME && \
    chown -R $USERNAME:$USERNAME $HOME

RUN mkdir -p $HOME

# Change to the nearcast user
USER gola
WORKDIR $WORKDIR

RUN wget https://repo1.maven.org/maven2/org/flywaydb/flyway-commandline/${FLYWAY_VERSION}/flyway-commandline-${FLYWAY_VERSION}.tar.gz \
  && tar -xzf flyway-commandline-${FLYWAY_VERSION}.tar.gz \
  && mv flyway-${FLYWAY_VERSION}/* . \
  && rm flyway-commandline-${FLYWAY_VERSION}.tar.gz

ENV PATH="${WORKDIR}/flyway:${PATH}"

# Install Go
ENV GO_VERSION 1.21.1
RUN wget https://go.dev/dl/go1.21.1.linux-amd64.tar.gz \
  && tar -xzf go${GO_VERSION}.linux-amd64.tar.gz \
  && rm go${GO_VERSION}.linux-amd64.tar.gz

ENV PATH="${WORKDIR}/go/bin:${PATH}"

ENV GOPATH="${WORKDIR}/go"
ENV PATH="${GOPATH}/bin:${PATH}"

COPY postgres/db/migrations /home/gola/sql
COPY postgres/infrastructure/migrate.sh /home/gola
