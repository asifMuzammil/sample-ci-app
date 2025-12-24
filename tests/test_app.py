from app.main import create_app

def test_health():
    app = create_app()
    client = app.test_client()
    res = client.get("/health")
    assert res.status_code == 200
    assert res.get_json()["status"] == "ok"

def test_version():
    app = create_app()
    client = app.test_client()
    res = client.get("/version")
    assert res.status_code == 200
    data = res.get_json()
    assert data["app"] == "sample-ci-app"
    assert "git_sha" in data
    assert "build_date" in data

