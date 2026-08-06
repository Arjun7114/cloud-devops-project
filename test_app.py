"""
Basic tests. In Phase 3, the CI pipeline will run these automatically
on every push. A pipeline that builds but never tests isn't worth much,
so we add tests now even though the app is tiny.
"""

from app import app


def test_home():
    client = app.test_client()
    response = client.get("/")
    assert response.status_code == 200
    assert "version" in response.get_json()


def test_health():
    client = app.test_client()
    response = client.get("/health")
    assert response.status_code == 200
    assert response.get_json()["status"] == "healthy"
