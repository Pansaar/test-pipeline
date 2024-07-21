set -e
if [ "$(docker ps -q -f name=testpipeline)" ]; then
    docker stop testpipeline
    docker rm testpipeline
fi
