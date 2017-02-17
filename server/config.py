from os import environ as env


class Config(object):

    ENVIRONMENT = env.get('LOGISTICS_WIZARD_ENV', 'DEV').upper()
    SECRET = env.get('SECRET', 'secret')

    OPENWHISK_URL = env.get('OPENWHISK_URL', 'https://openwhisk.ng.bluemix.net')
    OPENWHISK_AUTH = env.get('OPENWHISK_AUTH')
    OPENWHISK_PACKAGE = env.get('OPENWHISK_PACKAGE', 'lwr')
