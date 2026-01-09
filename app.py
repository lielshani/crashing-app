import os
from flask import Flask, jsonify

app = Flask(__name__)

app_mode = os.getenv("APP_MODE", "Production")
api_key = os.getenv("API_KEY", "MISSING")

@app.route("/")
def home():
    return jsonify({
        "status": "ok",
        "app_mode": app_mode,
        "api_key_present": api_key
    })

@app.route("/crash")
def crash():
    raise RuntimeError("Intentional crash")

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)
