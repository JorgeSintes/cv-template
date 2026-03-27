FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8

RUN apt-get update && apt-get install -y --no-install-recommends \
    make \
    pandoc \
    texlive-fonts-recommended \
    texlive-latex-extra \
    texlive-latex-recommended \
    texlive-plain-generic \
    texlive-pictures \
    texlive-xetex \
    fonts-roboto \
    ca-certificates \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /work

COPY . /work

CMD ["make", "cv", "letter"]
