"""
High level utilities, can be used by any of the layers (data, service,
interface) and should not have any dependency on Flask or request context.
"""
import requests, base64
from types import FunctionType
from os import environ as env
import json
from server.config import Config
from server.exceptions import APIException


def async_helper(args):
    """
    Calls the passed in function with the input arguments. Used to mitigate
    calling different functions during multiprocessing

    :param args:    Function and its arguments
    :return:        Result of the called function
    """

    # Isolate function arguments in their own tuple and then call the function
    func_args = tuple(y for y in args if type(y) != FunctionType)
    return args[0](*func_args)


def get_service_url(service_name):
    """
    Retrieves the URL of the service being called based on the environment
    that the controller is currently being run.

    :param service_name:    Name of the service being retrieved
    :return:                The endpoint of the input service name
    """

    if service_name == 'lw-erp':
        return env['ERP_SERVICE']
    else:
        raise APIException('Unrecognized service invocation')

def call_openwhisk(action, payload=None):
    """
    Calls and waits for the completion of an OpenWhisk action with the optional payload

    :param action:     The action to call
    :param payload:    An optional dictionary with arguments for the action
    :return:           The invocation result
    """

    url = '%s/api/v1/namespaces/_/actions/%s/%s?blocking=true' % (
        Config.OPENWHISK_URL,
        Config.OPENWHISK_PACKAGE,
        action
        )

    if payload is not None:
        payload_json = json.dumps(payload)
    else:
        payload_json = None

    headers = {
        'Authorization': "Basic %s" % base64.b64encode(Config.OPENWHISK_AUTH),
        'content-type': "application/json",
        'cache-control': "no-cache"
    }

    response = requests.request("POST", url, data=payload_json, headers=headers)
    body = json.loads(response.text)
    result = body.get('response').get('result')
    return json.dumps(result)
