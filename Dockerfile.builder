FROM maven:3

RUN apt-get update && apt-get install -qy git nodejs node-gyp
