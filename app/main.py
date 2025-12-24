from flask import Flask, jsonify
import os

def create_app():
    app = Flask(__name__)

    @app.get("/health")
    def health():
        return jsonify(status="ok")

    @app.get("/version")
    def version():
        return jsonify(
            app="sample-ci-app",
            git_sha=os.getenv("GIT_SHA", "unknown"),
            build_date=os.getenv("BUILD_DATE", "unknown"),
            build_number=os.getenv("BUILD_NUMBER", "local"),
            ci_stage=os.getenv("CI_STAGE", "local"),
        )

    return app

app = create_app()

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8090)

