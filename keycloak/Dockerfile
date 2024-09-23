# Our base Docker Image, usinging the quay.io.  The 
#    keycloak image uses micro RHEL image, but is so 
#    locked down that you can't install anything.
#FROM registry.access.redhat.com/ubi9 as ubi-micro-build
#FROM quay.io/keycloak/keycloak:latest
FROM keycloak/keycloak:24.0.2

COPY /setup.sh   /opt/keycloak/setup.sh

ENV KEYCLOAK_ADMIN=admin
ENV KEYCLOAK_ADMIN_PASSWORD=admin


# Original entrypoint for keycloak
#ENTRYPOINT ["/opt/keycloak/bin/kc.sh"]
# Start the KC server and then run our setup script
#ENTRYPOINT ["/opt/keycloak/bin/kc.sh", "start-dev"]
#CMD ["sh", "-c", "/opt/keycloak/setup.sh"]
#CMD ["/opt/keycloak/bin/kc.sh", "start-dev", "&&", "/opt/keycloak/setup.sh"]
ENTRYPOINT ["/opt/keycloak/setup.sh"]
#ENTRYPOINT ["sh"]