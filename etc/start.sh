
set -Ceu

docker build -t mydocker .
docker run -it --rm -v $(pwd):/md -v /var/run/docker.sock:/var/run/docker.sock mydocker

