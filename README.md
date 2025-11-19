# Install and Run
```
$ bundle config set --local path '.bundle/gems'
$ bundle install --jobs 4
$ bundle exec guard -i
```

# Running Tests
```
$ bundle config set --local without 'development'
$ bundle exec rspec
```
