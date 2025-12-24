PORT=8090

venv:
	python3 -m venv .venv

install: venv
	. .venv/bin/activate && pip install -r requirements.txt

test:
	. .venv/bin/activate && pytest -q

run:
	. .venv/bin/activate && python app/main.py

curl-health:
	curl -fsS http://localhost:$(PORT)/health

curl-version:
	curl -fsS http://localhost:$(PORT)/version

