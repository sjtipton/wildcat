# Wildcat

A Ruby Gem that exposes the wonderful goodness of the [Pro Football API](http://github.com/sjtipton/pro_football_api)

## Installation

Clone the repo from Github

    git clone git@github.com:sjtipton/wildcat.git

Install any dependencies

    bundle install

Build the gem

    bundle exec rake build

Install the gem

    ruby -S gem install ./pkg/wildcat-0.0.8.gem

To vendorize into a project

    cd path/to/project

    gem unpack wildcat -v 0.0.8 --target ./vendor/gems
