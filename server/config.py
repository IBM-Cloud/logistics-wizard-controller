from os import environ as env


class Config(object):

    ENVIRONMENT = env.get('LOGISTICS_WIZARD_ENV', 'DEV').upper()
    SECRET = env.get('SECRET', 'secret')
    FUNCTIONS_NAMESPACE_URL = env.get('FUNCTIONS_NAMESPACE_URL')
