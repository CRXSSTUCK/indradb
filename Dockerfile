FROM rust
WORKDIR /app
RUN apt-get update && apt-get install -y clang postgresql-contrib
RUN rustup default stable
CMD ./test.sh
