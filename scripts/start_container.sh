set -e
docker pull pansaar1553/test-pipeline-app
docker run -d -p 8000:8000 --name testpipeline pansaar1553/test-pipeline-app
