#rm -rf public/
#rm -rf tmp/cache/*
RAILS_ENV=production bundle exec rake assets:precompile
git add public/assets
#git rm public/assets
git add .
git commit -am "$1"
git push heroku master
#hb; git add .; git commit -a -m "Random commit message";hd; git push;
git push origin

