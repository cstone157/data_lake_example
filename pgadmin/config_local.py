SERVER_MODE = True
MASTER_PASSWORD_REQUIRED = True
AUTHENTICATION_SOURCES = ['oauth2', 'internal']
OAUTH2_AUTO_CREATE_USER = True
OAUTH2_CONFIG = [{
    'OAUTH2_NAME': 'MyKeyCloak',
    'OAUTH2_DISPLAY_NAME': 'MyKeyCloak',
    'OAUTH2_CLIENT_ID': 'pgadmin',
    'OAUTH2_CLIENT_SECRET': 'Kkr2mngidME0hXItaSTiAe9s',
    'OAUTH2_TOKEN_URL': 'https://mykeycloak/realms/datahub/protocol/openid-connect/token',
    'OAUTH2_AUTHORIZATION_URL': 'https://mykeycloak/realms/datahub/protocol/openid-connect/auth',
    'OAUTH2_API_BASE_URL': 'https://mykeycloak/realms/datahub/',
    'OAUTH2_USERINFO_ENDPOINT': 'https://mykeycloak/realms/datahub/protocol/openid-connect/userinfo',
    'OAUTH2_SCOPE': 'openid email profile',
    'OAUTH2_BUTTON_COLOR': '#51c65b;',
    'OAUTH2_SERVER_METADATA_URL': 'https://mykeycloak/realms/datahub/.well-known/openid-configuration'
}]