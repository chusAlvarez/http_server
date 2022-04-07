# syntax=docker/dockerfile:1
FROM ruby:3.0
COPY http_server.rb .
ENTRYPOINT ["ruby", "http_server.rb"]