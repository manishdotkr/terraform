# Use an official Node.js runtime as a parent image
FROM public.ecr.aws/lambda/nodejs:18

# Copy the JavaScript file to the container
WORKDIR ${LAMBDA_TASK_ROOT}
COPY . .

# Set the CMD to run the JS file when the container starts
CMD ["index.handler"]
