# Use the official Node.js 14 image as the base image
FROM node:16.16.0

ARG UID
ARG GID

# Update the package list, install sudo, create a non-root user, and grant password-less sudo permissions
RUN apt update && \
    apt install -y sudo && \
    addgroup --gid $GID nonroot && \
    adduser --uid $UID --gid $GID --disabled-password --gecos "" nonroot && \
    echo 'nonroot ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

# Set the non-root user as the default user
USER nonroot

# Set the working directory in the container
WORKDIR /home/nonroot/app

# Copy package.json and package-lock.json to the container
COPY --chown=nonroot:nonroot ./app/package*.json ./

# Install app dependencies
RUN npm install

# Copy the rest of the app's source code to the container
COPY --chown=nonroot:nonroot ./app /home/nonroot/app

RUN chmod -R 750 /home/nonroot/app

# Expose the port that the app will listen on
EXPOSE 3005

# Start the app
CMD ["node", "app.js"]