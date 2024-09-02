FROM gcr.io/distroless/static@sha256:ce46866b3a5170db3b49364900fb3168dc0833dfb46c26da5c77f22abb01d8c3
ARG TARGETOS
ARG TARGETARCH
COPY bin/powerdns-operator-${TARGETOS}-${TARGETARCH} /bin/powerdns-operator

# Run as UID for nobody
USER 65534

ENTRYPOINT ["/bin/powerdns-operator"]