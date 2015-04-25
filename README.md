## Welcome to Volunteer Tracker

### Getting Started

* `$ git clone git://github.com/omggroup/volunteer_tracker.git volunteer`
* `$ cd ./volunteer`
* `$ cp config/database.yml.example config/database.yml`
* `Configure your config/database.yml`
* `$ bundle install`
* `$ rake db:create`

### Import DB

There are 2 different application with separated DB:

for ggf_tracker branch
* `$ psql ggf_volunteer_tracker < ./db/ggf.psql`

for saf_tracker branch
* `$ psql saf_volunteer_tracker < ./db/saf.psql`

master branch is provided for common functional (both saf and gaf applications)

## Deploy to staging

Staging server of ggf_branch there - http://volunteer.23stages.com/

Staging server of saf_branch there - http://volunteer2.23stages.com/

Deploy ggf_tracker branch
* $ `cap staging deploy`

Deploy saf_tracker branch
* $ `cap staging2 deploy`

## Deploy to production
Deploy ggf_tracker_production branch
* $ `cap production deploy`

Deploy saf_tracker_production branch (not presently configured)
* $ `cap production2 deploy`

## Setup SSH Access
* $ `brew install ssh-copy-id`
* $ `ssh-copy-id username@hostname`

## Usefull commands
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
