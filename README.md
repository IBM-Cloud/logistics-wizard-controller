[Logistics Wizard](https://github.com/IBM-Cloud/logistics-wizard/tree/master#logistics-wizard-overview) / [Architecture](https://github.com/IBM-Cloud/logistics-wizard/tree/master#architecture) / logistics-wizard-controller

# Logistics Wizard Controller

This service orchestrates interaction between Logistics Wizard's services.

[![Deploy to IBM Cloud](https://bluemix.net/deploy/button.png)](https://bluemix.net/deploy?repository=https://github.com/IBM-Cloud/logistics-wizard-controller.git)

## Run the app on IBM Cloud

1. If you do not already have an IBM Cloud account, [sign up here][bluemix_signup_url].

2. Download and install the [IBM Cloud CLI][ibm_cli_url].

3. The Controller depends on the [ERP](https://github.com/IBM-Cloud/logistics-wizard-erp) and [Recommendation](https://github.com/IBM-Cloud/logistics-wizard-recommendation) microservices. Deploy them first.

4. Clone the Controller to your local environment from your terminal using the following command.

  ```bash
  git clone https://github.com/IBM-Cloud/logistics-wizard-controller.git
  ```

5. Change directory using `cd logistics-wizard-controller`.

6. Open the `manifest.yml` file and change the `host` value to something unique. The host you provide will determine the subdomain of the Controller's URL: `<host>.mybluemix.net`.

7. From the command line, connect to IBM Cloud and follow the prompts to log in.
	
  ```bash
  ibmcloud api https://api.ng.bluemix.net
  ibmcloud login
  ```

8. Push the controller to IBM Cloud.
	
  ```bash
  ibmcloud app push --no-start
  ```

9. Define the environment variable pointing to the ERP service.
  
  ```
  ibmcloud app set-env logistics-wizard-controller ERP_SERVICE <url-to-erp-service-here>
  ```

10. Define the [IBM Cloud Functions API Key](https://console.bluemix.net/openwhisk/learn/api-key) and the package where the actions of the Recommendation service have been deployed
  
  ```
  ibmcloud app set-env logistics-wizard-controller OPENWHISK_AUTH "your-api-key"
  ibmcloud app set-env logistics-wizard-controller OPENWHISK_PACKAGE lwr
  ```

11. Start the Controller.

  ```bash
  ibmcloud app start logistics-wizard-controller
  ```

And voila! You now have your very own instance of the Logistics Wizard's Controller running on IBM Cloud.

## Run the app locally

1. If you have not already, [download Python 2.7][download_python_url] and install it on your local machine.

2. Clone the Controller to your local environment from your terminal using the following command.
  
  ```bash
  git clone https://github.com/IBM-Cloud/logistics-wizard-controller.git
  ```

3. Change directory using `cd logistics-wizard-controller`.

4. In order to create an isolated development environment, you will be using Python's [virtualenv][virtualenv_url] tool. If you do not have it installed already, run
  
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

7. Start the app
  
  ```bash
  python bin/start_web.py
  ```

To override values for your local environment variables create a file named `.env.local` from the template below and edit the file to match your environment.

  ```
  cp template-env.local .env.local
  ```

## Testing

### Unit Tests
There are series of unit tests located in the [`server/tests`](server/tests) folder. The test suites are composed using the Python [unittest framework][unittest_docs_url]. To run the tests, execute the following command:

  ```bash
  python server/tests/run_unit_tests.py
  ```

### Integration Tests
Similar to the unit tests, integration tests validate the communication between the controller and other services such as the ERP service. These tests require the ERP service to be running.

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

The API and data models are defined in [this Swagger 2.0 file](swagger.yaml). You can view this file in the [Swagger Editor](http://editor.swagger.io/#/?import=https://raw.githubusercontent.com/IBM-Cloud/logistics-wizard-controller/master/swagger.yaml).

Use the Postman collection to help you get started with the controller API:  
[![Run in Postman](https://run.pstmn.io/button.svg)](https://app.getpostman.com/run-collection/b39a8c0ce27371fbd972#?env%5BLW_Prod%5D=W3sia2V5IjoiZXJwX2hvc3QiLCJ2YWx1ZSI6Imh0dHA6Ly9sb2dpc3RpY3Mtd2l6YXJkLWVycC5teWJsdWVtaXgubmV0LyIsInR5cGUiOiJ0ZXh0IiwiZW5hYmxlZCI6dHJ1ZSwiaG92ZXJlZCI6ZmFsc2V9LHsia2V5IjoiY29udHJvbGxlcl9ob3N0IiwidmFsdWUiOiJodHRwczovL2xvZ2lzdGljcy13aXphcmQubXlibHVlbWl4Lm5ldCIsInR5cGUiOiJ0ZXh0IiwiZW5hYmxlZCI6dHJ1ZSwiaG92ZXJlZCI6ZmFsc2V9XQ==)

## Troubleshooting

The primary source of debugging information for your IBM Cloud app is the logs. To see them, run the following command using the IBM Cloud CLI:

  ```
  $ ibmcloud app logs logistics-wizard-controller --recent
  ```
For more detailed information on troubleshooting your application, see the [Troubleshooting section](https://www.ng.bluemix.net/docs/troubleshoot/tr.html) in the IBM Cloud documentation.

## License

See [License.txt](License.txt) for license information.

## Status

| **master** | [![Build Status](https://travis-ci.org/IBM-Cloud/logistics-wizard-controller.svg?branch=master)](https://travis-ci.org/IBM-Cloud/logistics-wizard-controller) [![Coverage Status](https://coveralls.io/repos/github/IBM-Cloud/logistics-wizard-controller/badge.svg?branch=master)](https://coveralls.io/github/IBM-Cloud/logistics-wizard-controller?branch=master) |
| ----- | ----- |
| **dev** | [![Build Status](https://travis-ci.org/IBM-Cloud/logistics-wizard-controller.svg?branch=dev)](https://travis-ci.org/IBM-Cloud/logistics-wizard-controller) [![Coverage Status](https://coveralls.io/repos/github/IBM-Cloud/logistics-wizard-controller/badge.svg?branch=dev)](https://coveralls.io/github/IBM-Cloud/logistics-wizard-controller?branch=dev)|


<!--Links-->
[erp_github_url]: https://github.com/IBM-Cloud/logistics-wizard-erp
[recommendation_github_url]: https://github.com/IBM-Cloud/logistics-wizard-recommendation
[toolchain_github_url]: https://github.com/IBM-Cloud/logistics-wizard-toolchain
[bluemix_signup_url]: http://ibm.biz/logistics-wizard-signup
[download_python_url]: https://www.python.org/downloads/
[virtualenv_url]: http://docs.python-guide.org/en/latest/dev/virtualenvs/
[unittest_docs_url]: https://docs.python.org/3/library/unittest.html
[travis_url]: https://travis-ci.org/
[travis_profile_url]: https://travis-ci.org/profile/
[coveralls_url]: https://coveralls.io/
[coveralls_usage_url]: https://pypi.python.org/pypi/coveralls#usage-travis-ci
[ibm_cli_url]: https://console.bluemix.net/docs/cli/reference/bluemix_cli/get_started.html#getting-started
