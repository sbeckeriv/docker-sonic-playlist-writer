FROM ruby:2.5
ENV user
ENV token
ENV salt
ENV host
ENV path /playlists
ENV remove
ENV add
# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

CMD ["./main.rb ${user} ${token} ${salt} ${host} ${path} ${remove} ${add}"]
