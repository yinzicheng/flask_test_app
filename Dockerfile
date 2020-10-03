# first stage
FROM python:3.8-alpine AS build
WORKDIR /var/app/src

COPY requirements.txt .
# install dependencies to the local user directory (eg. /root/.local)
RUN pip install --user -r requirements.txt
# run test
COPY . .
RUN python -m pytest


# second unnamed stage
FROM python:3.8-alpine
WORKDIR /var/app/src

# copy only the dependencies installation from the 1st stage image
COPY --from=build /root/.local /root/.local
COPY . .

# update PATH environment variable
ENV PATH=/root/.local/bin:$PATH

EXPOSE 8082
CMD ["flask", "run", "-p", "8082"]
