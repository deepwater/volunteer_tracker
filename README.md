## Welcome to Volunteer Tracker

### Getting Started

* `$ git clone git://github.com/omggroup/volunteer_tracker.git volunteer`
* `$ cd ./volunteer`
* `$ cp config/database.yml.example config/database.yml`
* `Configure your config/database.yml`
* `$ bundle install`
* `$ rake db:setup`

## Deploy to staging

### Setup SSH Access
* $ `brew install ssh-copy-id`
* $ `ssh-copy-id username@hostname`

### Usefull commands
* deploy with migrations:
* `$ cap deploy:migrations`
* connect via ssh
* `$ cap ssh`
* show application logs
* `$ cap log`
* start rails console
* `$ cap console`

## Thanks for using Volunteer Tracker!

Hope, you'll enjoy Volunteer Tracker!

Cheers, [Droid Labs](http://droidlabs.pro).
