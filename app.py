from flask import Flask, render_template

app = Flask(__name__)

app_version = 1.0


@app.route('/')
def main():
    return 'Hello World!'


@app.route('/<username>')
def hello_world(username):
    return render_template('hello_world.html', username=username, app_version=app_version)


if __name__ == '__main__':
    app.run()
