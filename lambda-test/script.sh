docker build -t 637423302461.dkr.ecr.us-east-2.amazonaws.com/test:latest .
docker push 637423302461.dkr.ecr.us-east-2.amazonaws.com/test:latest

pg_dump -U postgres -f ./backup.sql -h legaltech-develop.ccfkdny6mmrt.us-east-2.rds.amazonaws.com legaltech-uat