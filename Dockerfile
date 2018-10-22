FROM python:2.7.13

ADD bin /app/bin
ADD server /app/server
ADD requirements.dev.txt /app/requirements.dev.txt
ADD requirements.txt /app/requirements.txt
ADD runtime.txt /app/runtime.txt
ADD sample_event.json /app/sample_event.json
ADD setup.py /app/setup.py

ENV ERP_SERVICE http://lw-erp:8080
ENV OPENWHISK_PACKAGE=lwr

ENV PORT 8080
EXPOSE 8080

RUN cd /app && pip install -r requirements.dev.txt

WORKDIR "/app"
CMD [ "gunicorn", "-w", "4", "bin.start_web:application" ]
