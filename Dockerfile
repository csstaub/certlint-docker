## Dockerfile for certlint/cablint

FROM ruby:2.3.0

RUN git clone https://github.com/awslabs/certlint && \
    cd certlint/build-x509helper && \
    git clone https://github.com/vlm/asn1c.git && \
    cd asn1c && \
    patch -p1 < ../asn1c.patch && \
    autoreconf -iv && \
    ./configure && \
    make && \
    cd examples && \
    cp ../../pkix-smimecaps.asn1 . && \
    cp ../../MiscAttr.asn1 . && \
    curl -O https://www.ietf.org/rfc/rfc3739.txt && \
    ./crfc2asn1.pl rfc3739.txt && \
    curl -O https://www.ietf.org/rfc/rfc3709.txt && \
    ./crfc2asn1.pl rfc3709.txt && \
    curl -O https://www.ietf.org/rfc/rfc3279.txt && \
    ./crfc2asn1.pl rfc3279.txt && \
    mkdir pkix1 && \
    cd pkix1 && \
    bash ../../../regen-pkix1-Makefile && \
    make && \
    chmod +x certlint-x509helper && \
    cp certlint-x509helper /usr/bin && \
    gem install simpleidn open4 public_suffix

 COPY run.sh /run.sh
 ENTRYPOINT ["/run.sh"]
