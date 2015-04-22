# Qmail-docker

# Usage

    docker build -t build-qmail -f build-qmail.dockerfile .
    docker run build-qmail > qmail.tar
    docker build -t run-qmail -f run-qmail.dockerfile .
