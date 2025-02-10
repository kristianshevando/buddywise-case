FROM python:3.11-alpine AS builder

WORKDIR /app

RUN apk add --no-cache gcc g++ musl-dev libffi-dev sqlite

COPY requirements.txt .
RUN pip install --no-cache-dir --prefix=/install -r requirements.txt

FROM python:3.11-alpine

WORKDIR /app

RUN apk add --no-cache curl

COPY --from=builder /install /usr/local

COPY . .

RUN python create_db.py

EXPOSE 8000

HEALTHCHECK --interval=5s --timeout=3s --start-period=10s --retries=3 \
  CMD curl --fail http://localhost:8000/docs || exit 1

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
