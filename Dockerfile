FROM python:3.8-slim-buster as builder

RUN apt update && apt install -y g++ libczmq-dev libffi-dev musl-dev build-essential
COPY . /src
WORKDIR /src
RUN pip install .

FROM python:3.8-slim-buster

RUN apt update && apt install -y python3-zmq
RUN adduser --gecos '' --shell /bin/false --disabled-password locust
COPY --from=builder /usr/local/lib/python3.8/site-packages /usr/local/lib/python3.8/site-packages
COPY --from=builder /usr/local/bin/locust /usr/local/bin/locust

EXPOSE 8089 5557

USER locust
ENTRYPOINT ["locust"]

# turn off python output buffering
ENV PYTHONUNBUFFERED=1
