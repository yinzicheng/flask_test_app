# first stage
FROM python:3.8-alpine AS builder
WORKDIR /var/app/src

COPY ./app/requirements.txt .
# install dependencies to the local user directory (eg. /root/.local)
RUN pip install --user -r requirements.txt
# run test
COPY ./app .
RUN python -m pytest


# second unnamed stage
FROM python:3.8-alpine
WORKDIR /var/app/src

# copy only the dependencies installation from the 1st stage image
COPY --from=builder /root/.local /root/.local
COPY ./app .

# update PATH environment variable
ENV PATH=/root/.local/bin:$PATH
ENV FLASK_APP=app.py
ENV FLASK_RUN_HOST=0.0.0.0

EXPOSE 5000
CMD ["flask", "run"]
