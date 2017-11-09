FROM mongo

LABEL maintainer "OUcare.com <oucaredev@oucare.com>"

RUN apt-get update \
 && apt-get install -y python-pip cron \
 && rm -rf /var/lib/apt/lists/* \
 && pip install awscli

WORKDIR /script

COPY . /script

ENTRYPOINT ["/script/start.sh"]
