from flask import Flask

app = Flask(__name__)


PORT = 5010


@app.route("/")
def hello_world():
    return "Hello1"


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=PORT, debug=True)
