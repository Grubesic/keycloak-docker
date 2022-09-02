FROM quay.io/keycloak/keycloak:latest as builder

ENV KC_DB=mysql
ENV KC_FEATURES="token-exchange"
ENV KC_HEALTH_ENABLED="true"
ENV KC_METRICS_ENABLED="true"
# Install custom providers
RUN curl -sL https://github.com/aerogear/keycloak-metrics-spi/releases/download/2.5.3/keycloak-metrics-spi-2.5.3.jar -o /opt/keycloak/providers/keycloak-metrics-spi-2.5.3.jar
RUN /opt/keycloak/bin/kc.sh build

FROM quay.io/keycloak/keycloak:latest
COPY --from=builder /opt/keycloak/ /opt/keycloak/
WORKDIR /opt/keycloak
ENV KC_PROXY="edge"
ENV KC_HTTP_ENABLED="true"
ENV KC_PROXY_MODE="edge"
ENTRYPOINT ["/opt/keycloak/bin/kc.sh"]
CMD ["start --optimized"]