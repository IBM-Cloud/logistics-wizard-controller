from os import environ as env


class Config(object):

    ENVIRONMENT = env.get('LOGISTICS_WIZARD_ENV', 'DEV').upper()
    SECRET = env.get('SECRET', 'secret')
