#!/bin/bash
set -e

# Pull the Docker image from Docker Hub
docker pull pansaar1553/simple-python-flask-app

# Run the Docker image as a container
docker run -d -p 8000:8000 pansaar1553/simple-python-flask-app

#This is a test