#!/bin/bash

# Copy sample config file to proper locations

cp config/blacklight.yml.sample config/blacklight.yml
cp config/database.yml.sample config/database.yml
cp config/doi.yml.sample config/doi.yml
cp config/fedora.yml.sample config/fedora.yml
cp config/solr.yml.sample config/solr.yml
cp config/initializers/scholar_uc.rb.sample config/initializers/scholar_uc.rb
cp config/initializers/hyrax.rb.sample config/initializers/hyrax.rb
cp config/initializers/devise.rb.sample config/initializers/devise.rb
cp config/environments/development.rb.sample config/environments/development.rb
cp config/environments/production.rb.sample config/environments/production.rb
cp config/authentication.yml.sample config/authentication.yml
cp config/initializers/riiif.rb.sample config/initializers/riiif.rb
