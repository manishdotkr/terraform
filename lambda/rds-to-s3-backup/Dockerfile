FROM public.ecr.aws/lambda/nodejs:18

WORKDIR ${LAMBDA_TASK_ROOT}

RUN yum update -y && \
    yum install amazon-linux-extras -y && \
    amazon-linux-extras enable postgresql14 && \
    yum install postgresql -y

COPY package*.json ./

RUN npm ci

COPY . ./

CMD ["index.handler"]
