FROM node:18-alpine AS builder

WORKDIR /app

COPY todo/package.json todo/package-lock.json ./
RUN npm ci --only=production

COPY todo ./
RUN npm run build

FROM node:18-alpine

WORKDIR /app

RUN apk add --no-cache curl

COPY --from=builder /app/build /app

RUN npm install -g serve

EXPOSE 3000

HEALTHCHECK --interval=5s --timeout=3s --start-period=10s --retries=3 \
  CMD curl --fail http://localhost:3000 || exit 1

CMD ["serve", "-s", "/app", "-l", "3000"]
