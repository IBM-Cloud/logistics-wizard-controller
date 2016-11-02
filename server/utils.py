"""
High level utilities, can be used by any of the layers (data, service,
interface) and should not have any dependency on Flask or request context.
"""
import re
from types import FunctionType
from os import environ as env
from json import loads
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
    elif service_name == 'lw-recommendation':
        return env['RECOMMENDATION_SERVICE']
    else:
        raise APIException('Unrecognized service invocation')
