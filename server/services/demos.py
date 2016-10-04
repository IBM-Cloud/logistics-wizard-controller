"""
Handle all actions on the demo resource and is responsible for making sure
the calls get routed to the ERP service appropriately. As much as possible,
the interface layer should have no knowledge of the properties of the demo
object and should just call into the service layer to act upon a demo resource.
"""
import requests
import json
from server.utils import get_service_url
from server.exceptions import (ResourceDoesNotExistException)
from server.exceptions import (APIException,
                               UnprocessableEntityException)

###########################
#         Utilities       #
###########################


def demo_to_dict(demo):
    """
    Convert an instance of the Demo model to a dict.

    :param demo:  An instance of the Demo model.
    :return:      A dict representing the demo.
    """
    return {
        'id': demo.id,
        'guid': demo.guid,
        'createdAt': demo.createdAt,
        'users': demo.users
    }


###########################
#         Services        #
###########################

def create_demo():
    """
    Create a new demo session in the ERP system.

    :return:         The created Demo model.
    """

    # Create and format request to ERP
    url = '%s/api/v1/Demos' % get_service_url('lw-erp')
    headers = {
        'content-type': "application/json",
        'cache-control': "no-cache"
    }

    try:
        response = requests.request("POST", url, headers=headers)
    except Exception as e:
        raise APIException('ERP threw error creating new Demo', internal_details=str(e))

    return response.text


def get_demo_by_guid(guid):
    """
    Retrieve a demo from the ERP system by guid.

    :param guid:    The demo's guid.

    :return:        An instance of the Demo.
    """

    # Create and format request to ERP
    url = '%s/api/v1/Demos/findByGuid/%s' % (get_service_url('lw-erp'), guid)
    headers = {'cache-control': "no-cache"}

    try:
        response = requests.request("GET", url, headers=headers)
    except Exception as e:
        raise APIException('ERP threw error retrieving demo', internal_details=str(e))

    # Check for possible errors in response
    if response.status_code == 404:
        raise ResourceDoesNotExistException('Demo does not exist',
                                            internal_details=json.loads(response.text).get('error').get('message'))

    return response.text


def delete_demo_by_guid(guid):
    """
    Delete a demo from the ERP system by guid.

    :param guid:    The demo's guid.
    """

    # Create and format request to ERP
    url = '%s/api/v1/Demos/%s' % (get_service_url('lw-erp'), guid)

    try:
        response = requests.request("DELETE", url)
    except Exception as e:
        raise APIException('ERP threw error deleting demo', internal_details=str(e))

    # Check for possible errors in response
    if response.status_code == 404:
        raise ResourceDoesNotExistException('Demo does not exist',
                                            internal_details=json.loads(response.text).get('error').get('message'))

    return


def get_demo_retailers(guid):
    """
    Retrieve retailers for a demo in the ERP system by guid.

    :param guid:    The demo's guid.
    :return:        An instance of the Demo.
    """

    # Create and format request to ERP
    url = '%s/api/v1/Demos/%s/retailers' % (get_service_url('lw-erp'), guid)
    headers = {'cache-control': "no-cache"}

    try:
        response = requests.request("GET", url, headers=headers)
    except Exception as e:
        raise APIException('ERP threw error retrieving retailers for demo',
                           internal_details=str(e))

    # Check for possible errors in response
    if response.status_code == 404:
        raise ResourceDoesNotExistException('Demo does not exist',
                                            internal_details=json.loads(response.text).get('error').get('message'))

    return response.text
