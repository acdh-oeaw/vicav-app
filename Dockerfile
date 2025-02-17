# syntax=docker/dockerfile:1-labs
FROM gliderlabs/herokuish:latest-24 AS builder
COPY --exclude=docker --exclude=.dockerignore --exclude=3rd-party/* --exclude=node_modules . /tmp/app
ARG BUILDPACK_URL
ARG CONTENT_REPO
ARG CONTENT_BRANCH
ENV USER=herokuishuser \
    CI=true \
    CONTENT_REPO=${CONTENT_REPO} \
    CONTENT_BRANCH=${CONTENT_BRANCH}
RUN --mount=type=secret,id=secrets_env,dst=/secrets_env \
  --mount=type=cache,target=/tmp/cache \
  if [ -f /secrets_env ]; then . /secrets_env; fi; \
  /bin/herokuish buildpack build

FROM gliderlabs/herokuish:latest-24
COPY --chown=herokuishuser:herokuishuser --from=builder --exclude=.heroku/basex/data.image /app/.heroku /app/.heroku
COPY --chown=herokuishuser:herokuishuser --from=builder /app/.jdk /app/.jdk
COPY --chown=herokuishuser:herokuishuser --from=builder /app/stat?c /app/static
COPY --chown=herokuishuser:herokuishuser --from=builder /app/images /app/images
COPY --chown=herokuishuser:herokuishuser --from=builder --exclude=.heroku --exclude=.jdk --exclude=static --exclude=images /app /app
COPY --chown=herokuishuser:herokuishuser --from=builder /app/.heroku/basex/data.image /app/.heroku/basex/data.image
ENV PORT=5000
ENV USER=herokuishuser
EXPOSE 5000
CMD ["/bin/herokuish", "procfile", "start", "web"]