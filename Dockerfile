FROM ruby:3.1.2

RUN apt-get update-qq && apt-get install -y libxml2 libxml2-dev libxslt libxslt-dev
WORKDIR /myapp
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock
RUN bundle install