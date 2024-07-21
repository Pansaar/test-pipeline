set -e
docker pull pansaar1553/test-pipeline-app
if [ "$(docker ps -a -q -f name=testpipeline)" ]; then
    docker rm testpipeline
fi
docker run -d -p 8000:8000 --name testpipeline pansaar1553/test-pipeline-app
