FROM ruby:3.2-slim AS builder

ENV APP_HOME=/app
WORKDIR $APP_HOME

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    build-essential \
    git \
    pkg-config \
    libffi-dev \
    libssl-dev \
  && rm -rf /var/lib/apt/lists/*

COPY Gemfile Gemfile.lock ./

RUN bundle config set without 'development test' \
  && bundle config set path vendor/bundle \
  && bundle install --jobs 4 --retry 3

COPY . .

FROM ruby:3.2-slim

ENV APP_HOME=/app \
    RACK_ENV=production \
    PORT=3333

WORKDIR $APP_HOME

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    libffi8 \
    libssl3 \
  && rm -rf /var/lib/apt/lists/*

COPY --from=builder $APP_HOME $APP_HOME

EXPOSE 3333

CMD ["bundle", "exec", "rackup", "-p", "3333", "-E", "production"]
