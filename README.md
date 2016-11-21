# Logistics Wizard Controller

| **master** | [![Build Status](https://travis-ci.org/IBM-Bluemix/logistics-wizard-controller.svg?branch=master)](https://travis-ci.org/IBM-Bluemix/logistics-wizard-controller) [![Coverage Status](https://coveralls.io/repos/github/IBM-Bluemix/logistics-wizard-controller/badge.svg?branch=master)](https://coveralls.io/github/IBM-Bluemix/logistics-wizard-controller?branch=master) |
| ----- | ----- |
| **dev** | [![Build Status](https://travis-ci.org/IBM-Bluemix/logistics-wizard-controller.svg?branch=dev)](https://travis-ci.org/IBM-Bluemix/logistics-wizard-controller) [![Coverage Status](https://coveralls.io/repos/github/IBM-Bluemix/logistics-wizard-controller/badge.svg?branch=dev)](https://coveralls.io/github/IBM-Bluemix/logistics-wizard-controller?branch=dev)|

**WORK IN PROGRESS**

This service is part of the larger [Logistics Wizard](https://github.com/IBM-Bluemix/logistics-wizard) project.

## Overview

This repository serves as the central server application for the Logistics Wizard application and acts as the main controller for interaction between the system's services.

[![Deploy to Bluemix](https://bluemix.net/deploy/button.png)](https://bluemix.net/deploy?repository=https://github.com/IBM-Bluemix/logistics-wizard-controller.git)

![Bluemix Deployments](https://deployment-tracker.mybluemix.net/stats/d4f7f6455442b0d2e1325dde70ab15ab/badge.svg)

## Running the app on Bluemix

1. If you do not already have a Bluemix account, [sign up here][bluemix_signup_url]

2. Download and install the [Cloud Foundry CLI][cloud_foundry_url] tool

3. Clone the app to your local environment from your terminal using the following command:

	```bash
	git clone https://github.com/IBM-Bluemix/logistics-wizard-controller.git
	```

4. `cd` into this newly created directory

5. Open the `manifest.yml` file and change the `host` value to something unique.

  The host you choose will determinate the subdomain of your application's URL:  `<host>.mybluemix.net`

6. Connect to Bluemix in the command line tool and follow the prompts to log in.

	```bash
	cf api https://api.ng.bluemix.net
	cf login
	```
7. Push the app to Bluemix.

	```bash
	cf push
	```

And voila! You now have your very own instance of Logistics Wizard running on Bluemix.

## Run the app locally

1. If you have not already, [download Python 2.7][download_python_url] and install it on your local machine.

2. Clone the app to your local environment from your terminal using the following command:

  ```bash
  git clone https://github.com/IBM-Bluemix/logistics-wizard-controller.git
  ```

3. `cd` into this newly created directory

4. In order to create an isolated development environment, we will be using Python's [virtualenv][virtualenv_url] tool. If you do not have it installed already, run

  ```bash
  pip install virtualenv
  ```

  Then create a virtual environment called `venv` by running

  ```bash
  virtualenv venv
  ```

5. Activate this new environment with

  ```bash
  source .env
  ```

6. Install module requirements

  ```bash
  pip install -r requirements.dev.txt
  ```

7. Finally, start the app

  ```bash
  python bin/start_web.py
  ```

To override values for your local environment variables create a `.env.local`.

## Testing

### Unit Tests
There are series of unit tests located in the [`server/tests`](server/tests) folder. The test suites are composed using the Python [unittest framework][unittest_docs_url]. To run the tests, execute the following command:

  ```bash
  python server/tests/run_unit_tests.py
  ```

### Integration Tests
Similar as the unit tests but they validate the communication between the controller
and the other services, like the ERP service. These tests require a ERP service to be running.

To run the tests, execute the following command:

 ```bash
 python server/tests/run_integration_tests.py
 ```

### Travis CI
One popular option for continuous integration is [Travis CI][travis_url]. We have provided a `.travis.yml` file in this repository for convenience. In order to set it up for your repository, take the following actions:

1. Go to your [Travis CI Profile][travis_profile_url]

2. Check the box next to your logistics-wizard GitHub repository and then click the settings cog

3. Create the following environment variables
	- `LOGISTICS_WIZARD_ENV` - TEST

Thats it! Now your future pushes to GitHub will be built and tested by Travis CI.

### Code Coverage Tests
If you would like to perform code coverage tests as well, you can use [coveralls][coveralls_url] to perform this task. If you are using [Travis CI][travis_url] as your CI tool, simply replace `python` in your test commands with `coverage run` and then run `coveralls` as follows:

  ```bash
  $ coverage run server/tests/run_unit_tests.py
  $ coverage --append run server/tests/run_integration_tests.py
  $ coveralls
  ```

To determine how to run coveralls using another CI tool or for more in-depth instructions, check out the [coveralls usage documentation][coveralls_usage_url].

**Note**: To pass, the integration tests require an [ERP service][erp_github_url] to be running.


## API documentation
The API methods that this component exposes requires the discovery of dependent services, however, the API will gracefully fail when they are not available.

The API and data models are defined in [this Swagger 2.0 file](swagger.yaml). You can view this file in the [Swagger Editor](http://editor.swagger.io/#/?import=https://raw.githubusercontent.com/IBM-Bluemix/logistics-wizard-controller/master/swagger.yaml).

Use the Postman collection to help you get started with the controller API:  
[![Run in Postman](https://run.pstmn.io/button.svg)](https://app.getpostman.com/run-collection/b39a8c0ce27371fbd972#?env%5BLW_Prod%5D=W3sia2V5IjoiZXJwX2hvc3QiLCJ2YWx1ZSI6Imh0dHA6Ly9sb2dpc3RpY3Mtd2l6YXJkLWVycC5teWJsdWVtaXgubmV0LyIsInR5cGUiOiJ0ZXh0IiwiZW5hYmxlZCI6dHJ1ZSwiaG92ZXJlZCI6ZmFsc2V9LHsia2V5IjoiY29udHJvbGxlcl9ob3N0IiwidmFsdWUiOiJodHRwczovL2xvZ2lzdGljcy13aXphcmQubXlibHVlbWl4Lm5ldCIsInR5cGUiOiJ0ZXh0IiwiZW5hYmxlZCI6dHJ1ZSwiaG92ZXJlZCI6ZmFsc2V9XQ==)

## Contribute
Please check out our [Contributing Guidelines](https://github.com/IBM-Bluemix/logistics-wizard/blob/master/.github/CONTRIBUTING.md) for detailed information on how you can lend a hand to the Logistics Wizard demo implementation effort.

## Troubleshooting

The primary source of debugging information for your Bluemix app is the logs. To see them, run the following command using the Cloud Foundry CLI:

  ```
  $ cf logs logistics-wizard-controller --recent
  ```
For more detailed information on troubleshooting your application, see the [Troubleshooting section](https://www.ng.bluemix.net/docs/troubleshoot/tr.html) in the Bluemix documentation.

## Privacy Notice

The logistics-wizard sample web application includes code to track deployments to Bluemix and other Cloud Foundry platforms. The following information is sent to a [Deployment Tracker](https://github.com/IBM-Bluemix/cf-deployment-tracker-service) service on each deployment:

* Python package version
* Python repository URL
* Application Name (`application_name`)
* Space ID (`space_id`)
* Application Version (`application_version`)
* Application URIs (`application_uris`)
* Labels of bound services
* Number of instances for each bound service and associated plan information

This data is collected from the `setup.py` file in the sample application and the `VCAP_APPLICATION` and `VCAP_SERVICES` environment variables in IBM Bluemix and other Cloud Foundry platforms. This data is used by IBM to track metrics around deployments of sample applications to IBM Bluemix to measure the usefulness of our examples, so that we can continuously improve the content we offer to you. Only deployments of sample applications that include code to ping the Deployment Tracker service will be tracked.

### Disabling Deployment Tracking

Deployment tracking can be disabled by removing `cf_deployment_tracker.track()` from the `server/web/__init__.py` file.

## License

See [License.txt](License.txt) for license information.

<!--Links-->
[erp_github_url]: https://github.com/IBM-Bluemix/logistics-wizard-erp
[recommendation_github_url]: https://github.com/IBM-Bluemix/logistics-wizard-recommendation
[toolchain_github_url]: https://github.com/IBM-Bluemix/logistics-wizard-toolchain
[bluemix_signup_url]: http://ibm.biz/logistics-wizard-signup
[cloud_foundry_url]: https://github.com/cloudfoundry/cli
[download_python_url]: https://www.python.org/downloads/
[virtualenv_url]: http://docs.python-guide.org/en/latest/dev/virtualenvs/
[unittest_docs_url]: https://docs.python.org/3/library/unittest.html
[travis_url]: https://travis-ci.org/
[travis_profile_url]: https://travis-ci.org/profile/
[coveralls_url]: https://coveralls.io/
[coveralls_usage_url]: https://pypi.python.org/pypi/coveralls#usage-travis-ci
