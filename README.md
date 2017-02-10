## PHP_CodeSniffer Docker Container.
[![Docker Pulls](https://img.shields.io/docker/pulls/rvannauker/phpcs.svg)](https://hub.docker.com/r/rvannauker/phpcs/) [![Docker Stars](https://img.shields.io/docker/stars/rvannauker/phpcs.svg)](https://hub.docker.com/r/rvannauker/phpcs/) [![](https://images.microbadger.com/badges/image/rvannauker/phpcs:latest.svg)](https://microbadger.com/images/rvannauker/phpcs:latest) [![GitHub issues](https://img.shields.io/github/issues/RichVRed/docker-phpcs.svg)](https://github.com/RichVRed/docker-phpcs) [![license](https://img.shields.io/github/license/RichVRed/docker-phpcs.svg)](https://tldrlegal.com/license/mit-license)

Docker container to install and run phpcs

### Installation / Usage
1. Install the rvannauker/phpcs container:
```bash
docker pull rvannauker/phpcs
```
2. Run phpcs through the phpcs container:
```bash
sudo docker run --rm --volume $(pwd):/workspace --name="phpcs" "rvannauker/phpcs" --colors --standard="PSR2" -v {destination}
```

### Download the source:
To run, test and develop the PHP_CodeSniffer Dockerfile itself, you must use the source directly:
1. Download the source:
```bash
git clone https://github.com/RichVRed/docker-phpcs.git
```
2. Build the container:
```bash
sudo docker build --force-rm --tag "rvannauker/phpcs" --file phpcs.dockerfile .
```
3. Test running the container:
```bash
 $ docker run rvannauker/phpcs --help
```