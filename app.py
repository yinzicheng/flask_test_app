import time
from flask import Flask, render_template
import redis

app = Flask(__name__)
app_version = 1.0

cache = redis.Redis(host='redis', port=6379)


def get_hit_count():
    retries = 5
    while True:
        try:
            return cache.incr('hits')
        except redis.exceptions.ConnectionError as exc:
            if retries == 0:
                raise exc
            retries -= 1
            time.sleep(0.5)


@app.route('/main')
def main():
    return {'hello': 'world'}


@app.route('/')
def hello():
    count = get_hit_count()
    return 'Hello World! I have been seen {} times.\n'.format(count)


@app.route('/<username>')
def hello_world(username):
    return render_template('hello_world.html', username=username, app_version=app_version)


if __name__ == '__main__':
    app.run()
