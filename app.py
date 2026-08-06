"""
A tiny Flask web app. This is the application we'll containerize,
push to a registry, run through CI/CD, and deploy to Kubernetes on AWS.

Keep it small on purpose — the *app* isn't the point. The pipeline and
infrastructure around it are what we're demonstrating.
"""

import os
from flask import Flask, jsonify

app = Flask(__name__)

# A version string. Later, when we set up GitOps, changing this value
# and pushing to Git is an easy way to *see* the cluster update itself.
APP_VERSION = os.environ.get("APP_VERSION", "1.0.0")


@app.route("/")
def home():
    """Main endpoint — returns a friendly message."""
    return jsonify(
        message="Hello from my cloud DevOps project!",
        version=APP_VERSION,
    )


@app.route("/health")
def health():
    """
    Health check endpoint.
    Kubernetes will call this to know whether the app is alive.
    Load balancers and monitoring use it too.
    """
    return jsonify(status="healthy"), 200


if __name__ == "__main__":
    # host=0.0.0.0 is important: it makes the app reachable from
    # outside the container (not just localhost inside it).
    port = int(os.environ.get("PORT", 5000))
    app.run(host="0.0.0.0", port=port)
