"""
Handle all actions on the weather resource.
"""
import json
import requests
from server.utils import call_openwhisk
from server.exceptions import ResourceDoesNotExistException, APIException

def get_recommendations(demoGuid):
    """
    Get recommendations
    """

    try:
        payload = dict()
        payload['demoGuid'] = demoGuid
        response = call_openwhisk('retrieve', payload)
    except Exception as e:
        raise APIException('KO', internal_details=str(e))

    return response

def acknowledge_recommendation(demoGuid, recommendationId):
    """
    Acknowledge the given recommendation
    """

    try:
        payload = dict()
        payload['demoGuid'] = demoGuid
        payload['recommendationId'] = recommendationId
        response = call_openwhisk('acknowledge', payload)
    except Exception as e:
        raise APIException('KO', internal_details=str(e))

    return response

def trigger_simulation(demoGuid):
    """
    Trigger a simulation in the given demo
    Creates a Snow Storm in the DC area
    """

    try:
        payload = dict()
        payload['demoGuid'] = demoGuid
        event = dict()
        event = json.loads(open('./sample_event.json').read())
        payload['event'] = event
        response = call_openwhisk('recommend', payload)
    except Exception as e:
        raise APIException('KO', internal_details=str(e))

    return response

def get_observations(latitude, longitude):
    """
    Return observations for the given location
    """

    try:
        payload = dict()
        payload['latitude'] = latitude
        payload['longitude'] = longitude
        response = call_openwhisk('observations', payload)
    except Exception as e:
        raise APIException('KO', internal_details=str(e))

    return response
