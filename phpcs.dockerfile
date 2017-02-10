# BUILD:
# docker build --force-rm --tag "rvannauker/phpcs" --file phpcs.dockerfile .
# SUGGESTED BUILD:
# docker build --force-rm --build-arg COLORS=1 --build-arg SHOW_PROGRESS=1 --build-arg REPORT_WIDTH=140 --build-arg ENCODING=utf-8 --build-arg REPORT_FORMAT=full --tag "rvannauker/phpcs" --file phpcs.dockerfile .
# RUN:
# docker run --rm --volume $(pwd):/workspace --name="phpcs" "rvannauker/phpcs" --config-set colors=1 --standard="PSR2" -v {destination}
# PACKAGE: PHP_CodeSniffer
# PACKAGE REPOSITORY: https://github.com/squizlabs/PHP_CodeSniffer
# DESCRIPTION: PHP_CodeSniffer tokenizes PHP, JavaScript and CSS files and detects violations of a defined set of coding standards.
# CONFIGURATION: https://github.com/squizlabs/PHP_CodeSniffer/wiki/Configuration-Options
FROM alpine:latest
MAINTAINER Richard Vannauker <richard.vannauker@gmail.com>
# Build-time metadata as defined at http://label-schema.org
ARG BUILD_DATE
ARG VCS_REF
ARG VERSION
LABEL     org.label-schema.schema-version="1.0" \
          org.label-schema.build-date="$BUILD_DATE" \
          org.label-schema.version="$VERSION" \
          org.label-schema.name="" \
          org.label-schema.description="" \
          org.label-schema.vendor="SEOHEAT LLC" \
          org.label-schema.url="" \
          org.label-schema.vcs-ref="$VCS_REF" \
          org.label-schema.vcs-url="" \
          org.label-schema.usage="" \
          org.label-schema.docker.cmd="" \
          org.label-schema.docker.cmd.devel="" \
          org.label-schema.docker.cmd.test="" \
          org.label-schema.docker.cmd.debug="" \
          org.label-schema.docker.cmd.help="" \
          org.label-schema.docker.params="" \
          org.label-schema.rkt.cmd="" \
          org.label-schema.rkt.cmd.devel="" \
          org.label-schema.rkt.cmd.test="" \
          org.label-schema.rkt.cmd.debug="" \
          org.label-schema.rkt.cmd.help="" \
          org.label-schema.rkt.params="" \
          com.amazonaws.ecs.task-arn="" \
          com.amazonaws.ecs.container-name="" \
          com.amazonaws.ecs.task-definition-family="" \
          com.amazonaws.ecs.task-definition-version="" \
          com.amazonaws.ecs.cluster=""

RUN mkdir -p /workspace
WORKDIR /workspace
VOLUME /workspace

# Additional tools
ADD https://getcomposer.org/composer.phar /usr/local/bin/composer

# PHP binary & extensions
RUN echo "http://dl-4.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
    && apk update \
    && apk add --no-cache \
           php5 \
           php5-json \
           php5-openssl \
           php5-phar \
           php5-ctype \
           git \
           bash \
    && rm -rf /var/cache/apk/*

# Add path to composed tools and set other environment variables
ENV PATH="/root/.composer/vendor/bin:$PATH" \
    COLORS=${COLORS:-0} \
    DEFAULT_STANDARD=${DEFAULT_STANDARD:-PSR2} \
    ENCODING=${ENCODING:-} \
    ERROR_SEVERITY=${ERROR_SEVERITY:-} \
    IGNORE_ERRORS_ON_EXIT=${IGNORE_ERRORS_ON_EXIT:-} \
    IGNORE_WARNINGS_ON_EXIT=${IGNORE_WARNINGS_ON_EXIT:-} \
    INSTALLED_PATHS=${INSTALLED_PATHS:-} \
    REPORT_FORMAT=${REPORT_FORMAT:-summary} \
    REPORT_WIDTH=${REPORT_WIDTH:-120} \
    SEVERITY=${SEVERITY:-} \
    SHOW_PROGRESS=${SHOW_PROGRESS:-1} \
    SHOW_WARNINGS=${SHOW_PROGRESS:-0} \
    TAB_WIDTH=${TAB_WIDTH:-} \
    WARNING_SEVERITY=${WARNING_SEVERITY:-}

#    /root/.composer/vendor/bin/phpcs --config-set csslint_path /path/to/csslint && \
#    /root/.composer/vendor/bin/phpcs --config-set gjslint_path /path/to/gjslint && \
#
#    /root/.composer/vendor/bin/phpcs --config-set rhino_path /path/to/rhino && \
#    /root/.composer/vendor/bin/phpcs --config-set jshint_path /path/to/jshint.js && \
#    /root/.composer/vendor/bin/phpcs --config-set jslint_path /path/to/jslint.js && \
#
#    /root/.composer/vendor/bin/phpcs --config-set jsl_path /path/to/jsl && \
#    /root/.composer/vendor/bin/phpcs --config-set zend_ca_path /path/to/ZendCodeAnalyzer

# Make the tools executable and install the tools
RUN chmod +x /usr/local/bin/composer \
    && /usr/local/bin/composer global require \
	      'squizlabs/php_codesniffer=2.7.1' \
	      'wimg/php-compatibility=dev-master' \
          'simplyadmire/composer-plugins=@dev' \
    && mkdir -p /root/.composer/vendor/squizlabs/php_codesniffer/CodeSniffer/Standards/PHPCompatibility \
    && cp -r /root/.composer/vendor/wimg/php-compatibility/* /root/.composer/vendor/squizlabs/php_codesniffer/CodeSniffer/Standards/PHPCompatibility

CMD (echo "${COLORS}" | xargs -r phpcs --config-set colors && echo "${DEFAULT_STANDARD}" | xargs -r phpcs --config-set default_standard && echo "${ENCODING}" | xargs -r phpcs --config-set encoding && echo "${ERROR_SEVERITY}" | xargs -r phpcs --config-set error_severity && echo "${IGNORE_ERRORS_ON_EXIT}" | xargs -r phpcs --config-set ignore_errors_on_exit && echo "${IGNORE_WARNINGS_ON_EXIT}" | xargs -r phpcs --config-set ignore_warnings_on_exit && echo "${INSTALLED_PATHS}" | xargs -r phpcs --config-set installed_paths && echo "${REPORT_FORMAT}" | xargs -r phpcs --config-set report_format && echo "${REPORT_WIDTH}" | xargs -r phpcs --config-set report_width && echo "${SEVERITY}" | xargs -r phpcs --config-set severity && echo "${SHOW_PROGRESS}" | xargs -r phpcs --config-set show_progress && echo "${SHOW_WARNINGS}" | xargs -r phpcs --config-set show_warnings && echo "${TAB_WIDTH}" | xargs -r phpcs --config-set tab_width && echo "${WARNING_SEVERITY}" | xargs -r phpcs --config-set warning_severity)
ENTRYPOINT ["phpcs"]

# Supported Coding Standards: MySource, PEAR, PHPCS, PHPCompatibility, PSR1, PSR2, Squiz and Zend