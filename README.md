Apollo
======

A [GeoRSS](http://en.wikipedia.org/wiki/GeoRSS) aggregator and augmented reality server for [Layar](http://layar.com/)

© 2012 Adrian Short and Charlotte Gilhooly at [Headline Data](http://headlinedata.com/)

This software was commissioned by [Talk About Local](http://talkaboutlocal.org.uk/) as part of the [HypARlocal](http://talkaboutlocal.org.uk/ar/) project.

HypARlocal is funded by [NESTA](http://www.nesta.org.uk/destination_local) and the [Nominet Trust](http://www.nominettrust.org.uk/).

What it does
------------

* Periodically pulls from a list of subscribed GeoRSS feeds into a local database
* Serves requests from Layar in JSON format for posts (points of interest) within a radius of a specified point.

Requirements
------------

* Rails 3
* MongoDB
* MongoMapper
* Feedzilla


Installation
------------

Before installing/deploying:

    $ export APOLLO_HOSTNAME=example.org
    
On Heroku:

    $ heroku config:add APOLLO_HOSTNAME=example.org

Replace `example.org` with your own hostname. When running locally this will probably be `localhost:3000`.

Set up a cron job or other scheduler to run

    $ rake get_all_feeds
    
once per hour or to taste.

Now create yourself a user account from the console:

    $ rails c
    > User.create :email => "me@example.org", :password => "verysecret", :password_confirmation => "verysecret"
