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

for master branch
* `$ psql volunteer_tracker < ./db/ggf_data.psql`

for event_hub branch
* `$ psql volunteer_tracker_event_hub < ./db/eh_data.psql`

## Deploy to staging

Staging server of master there - http://volunteer.23stages.com/ (admin credentials - admin@example.com // password)

Staging server of event_hub there - http://volunteer2.23stages.com/

Deploy master branch
* $ `cap staging deploy`

Deploy event_hub branch
* $ `cap staging2 deploy`

## Deploy to production
Deploy master branch
* $ `cap production deploy`

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
