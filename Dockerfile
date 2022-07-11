FROM python:3.9-alpine3.13
LABEL maintainer="sethu palaniappan"

#This instructs Python to run in UNBUFFERED mode, which is recommended when using Python inside a Docker container.
#The reason for this is that it does not allow Python to buffer outputs; instead, it prints output directly, 
#avoiding some complications in the docker image when running your Python application.

ENV PYTHONUNBUFFERED 1

COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app /app
WORKDIR /app
EXPOSE 8000

ARG DEV=false
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ $DEV = "true" ]; \
        then /py/bin/pip install -r /tmp/requirements.dev.txt ; \
    fi && \
    rm -rf /tmp && \
    adduser \
        --disabled-password \
        --no-create-home \
        django-user

ENV PATH="/py/bin:$PATH"

USER django-user
