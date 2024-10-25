FROM public.ecr.aws/lambda/nodejs:18

RUN curl -o /usr/bin/pg_dump https://get.enterprisedb.com/postgresql/postgresql-13.2-1-linux-x64.run && \
    chmod +x /usr/bin/pg_dump && \
    curl -o /usr/bin/psql https://get.enterprisedb.com/postgresql/postgresql-13.2-1-linux-x64.run && \
    chmod +x /usr/bin/psql

WORKDIR /var/runtime

COPY package*.json ./

RUN npm ci

COPY . ./


CMD ["index.handler"]
