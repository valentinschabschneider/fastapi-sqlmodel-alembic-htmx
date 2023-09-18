FROM python:3.11 as requirements

WORKDIR /tmp

RUN pip install poetry

COPY ./pyproject.toml ./poetry.lock* /tmp/

RUN poetry export -f requirements.txt --output requirements.txt --without-hashes

FROM tiangolo/uvicorn-gunicorn-fastapi:python3.11-slim

COPY --from=requirements /tmp/requirements.txt /app/requirements.txt

# required for psycopg2
RUN apt-get update && apt-get -y install libpq-dev gcc

RUN pip install --no-cache-dir --upgrade -r /app/requirements.txt

RUN apt-get -y remove libpq-dev gcc 

COPY ./app /app/app