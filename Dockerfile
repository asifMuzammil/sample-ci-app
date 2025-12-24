# ---- builder stage ----
FROM python:3.12-slim AS builder
WORKDIR /build

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# ---- runtime stage ----
FROM python:3.12-slim
WORKDIR /app

# Build args
ARG GIT_SHA=unknown
ARG BUILD_DATE=unknown
ARG BUILD_NUMBER=local

# Env for runtime
ENV GIT_SHA=${GIT_SHA}
ENV BUILD_DATE=${BUILD_DATE}
ENV BUILD_NUMBER=${BUILD_NUMBER}
ENV CI_STAGE=runtime

# Copy only installed deps from builder (fast + clean)
COPY --from=builder /usr/local /usr/local

COPY app ./app

EXPOSE 8080
CMD ["gunicorn", "-b", "0.0.0.0:8080", "app.main:app"]

