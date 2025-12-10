# syntax=docker/dockerfile:1

FROM node:20-alpine AS builder
ARG VITE_BASE_PATH=/
ARG ENV_STAGE=dev
ENV VITE_BASE_PATH=$VITE_BASE_PATH
WORKDIR /app

COPY FE/heoby_web/package*.json ./
RUN npm ci

COPY FE/heoby_web/ ./
COPY config/${ENV_STAGE}/.env.frontend /tmp/.env.frontend
RUN set -a \
  && . /tmp/.env.frontend \
  && set +a \
  && npm run build \
  && rm -f /tmp/.env.frontend

FROM nginx:1.27-alpine
COPY deploy/nginx/default.conf /etc/nginx/conf.d/default.conf
COPY --from=builder /app/dist /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
