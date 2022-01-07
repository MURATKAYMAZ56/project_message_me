# syntax=docker/dockerfile:1
FROM ruby:2.5
ARG http_proxy='http://10.21.107.6:8080'
ARG https_proxy='http://10.21.107.6:8080'
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client yarn
WORKDIR /myapp
COPY Gemfile /myapp/Gemfile

# PLP add extra bundler install
RUN gem install bundler:2.1.4
RUN https_proxy='http://10.21.107.6:8080'  bundle install

# PLP add proper yarn install
RUN apt remove -y cmdtest
RUN http_proxy=http://10.21.107.6:8080  apt install -y --no-install-recommends npm
RUN https_proxy=http://10.21.107.6:8080  npm install --global yarn

# Add a script to be executed every time the container starts.
# PLP In the script a precompile of the assets is done.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Configure the main process to run when running the image
CMD ["rails", "server", "-b", "0.0.0.0"]
