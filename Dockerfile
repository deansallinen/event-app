FROM elixir:alpine

RUN apk update && \
	apk add -f postgresql-client

# app directory for Elixir projects
RUN mkdir /app
COPY . /app
WORKDIR /app

RUN mix local.hex --force

# compile the project
RUN mix do compile

CMD ["sh", "/app/entrypoint.sh"]
