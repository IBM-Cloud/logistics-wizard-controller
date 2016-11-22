"""
The REST interface for the Weather Recommendation API
"""
import server.services.weather as weather_service
from flask import g, request, Response, Blueprint
from server.web.utils import get_json_data, check_null_input, logged_in

weather_v1_blueprint = Blueprint('weather_v1_api', __name__)

@weather_v1_blueprint.route('/weather/recommendations', methods=['GET'])
@logged_in
def get_recommendations():
    """
    Return recommendations.

    :return: the list of recommendations

    """
    recommendations = weather_service.get_recommendations(g.auth['guid'])
    return Response(recommendations,
                    status=200,
                    mimetype='application/json')

@weather_v1_blueprint.route('/weather/acknowledge', methods=['POST'])
@logged_in
def acknowledge_recommendation():
    """
    Acknowledge a recommendation.
    """
    body = get_json_data(request)

    response = weather_service.acknowledge_recommendation(g.auth['guid'], body.get('id'))
    return Response(response,
                    status=200,
                    mimetype='application/json')

@weather_v1_blueprint.route('/weather/simulate', methods=['POST'])
@logged_in
def trigger_simulation():
    """
    Trigger a simulation for the given demo.
    """
    response = weather_service.trigger_simulation(g.auth['guid'])
    return Response(response,
                    status=200,
                    mimetype='application/json')

@weather_v1_blueprint.route('/weather/observations', methods=['POST'])
@logged_in
def get_observations():
    """
    Return observations for the given location.
    :return: observations for the given location.
    """
    body = get_json_data(request)

    observations = weather_service.get_observations(body.get('latitude'), body.get('longitude'))
    return Response(observations,
                    status=200,
                    mimetype='application/json')
