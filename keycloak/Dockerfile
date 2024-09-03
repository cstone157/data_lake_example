# Our base Docker Image, usinging the quay.io.  The 
#    keycloak image uses micro RHEL image, but is so 
#    locked down that you can't install anything.
#FROM registry.access.redhat.com/ubi9 as ubi-micro-build
#FROM quay.io/keycloak/keycloak:latest
FROM quay.io/keycloak/keycloak:24.0.2

COPY /keycloak_startup.sh   /opt/keycloak

# Original entrypoint for keycloak
#ENTRYPOINT ["/opt/keycloak/keycloak_startup.sh"]

# Our custom startup, that will create our 
ENTRYPOINT ["/opt/keycloak/keycloak_startup.sh"]