FROM ruby:2.5
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev 
ENV user=""
ENV token=""
ENV salt=""
ENV host=""
ENV path=""
ENV remove=""
ENV add=""
# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY main.rb ./

RUN echo 'ping localhost &' > /bootstrap.sh
RUN echo 'sleep infinity' >> /bootstrap.sh
RUN chmod +x /bootstrap.sh
RUN ruby ./main.rb ${user} ${token} ${salt} ${host} ${path} ${remove} ${add} &> error
CMD exec /bin/sh -c "sleep 500"
