from flask import Flask

app = Flask(__name__)


PORT = 5010


@app.route("/remember-request")
def remember_request():
    # TODO
    # save tweet (message/status) id
    # understand the time request
    # pseudocode:
    # match = re.search(r"@melembredisto (?:em|daqui) (\d+(?:\.\d+)?)\s*(\w+)", message)
    # if match:
    #     value = int(match.group(1))
    #     measure = match.group(2)
    # answer the request with a new message on the thread
    # save this response id with requester username and time to remember on db
    return "ok"


@app.route("/mention-person")
def mention_person():
    # TODO
    # this gonna be trigger by cronjob hourly
    # fetch from db tweets to answer
    # add mention on thread
    return "ok"


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=PORT, debug=True)
