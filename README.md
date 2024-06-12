# Personal Website

Hi, this is my personal website created with github-pages/jekyll.
The content for the site is located in `docs/`

## Local Setup

https://jekyllrb.com/docs/installation/macos/

```sh
# Install Ruby
brew install chruby ruby-install xz
ruby-install ruby 3.1.3

# Configure Env for Ruby
echo "source $(brew --prefix)/opt/chruby/share/chruby/chruby.sh" >> ~/.zshrc
echo "source $(brew --prefix)/opt/chruby/share/chruby/auto.sh" >> ~/.zshrc
echo "chruby ruby-3.1.3" >> ~/.zshrc # run 'chruby' to see actual version

# Restart, check ruby version
ruby -v

# Install
bundle install
```

```sh
./start.sh
```

Go to http://localhost:4000/
