# Use the official Ruby image as the base
FROM ruby:3.1

# Install system dependencies, including SQLite3 and its development libraries
RUN apt-get update -qq && apt-get install -y \
  nodejs \
  sqlite3 \
  libsqlite3-dev

# Set the working directory inside the container
WORKDIR /app

# Copy Gemfile and Gemfile.lock first to leverage Docker caching
COPY Gemfile Gemfile.lock ./

# Install Bundler and the gems specified in the Gemfile
RUN gem install bundler && bundle install

# Copy the rest of the application code
COPY . .

# Expose port 3000 so the container can be accessed externally
EXPOSE 3000

# Start the Rails server
CMD ["rails", "server", "-b", "0.0.0.0"]
