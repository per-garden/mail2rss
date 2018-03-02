# Presentation

Mail2rss is a rails application combining email retriever and rss server. As such it is very basic. Emails are fetched from one single email source. The most recent email is stored locally and provided as RSS stream.


## Features

 - Email retriever
 - RSS server


# Installation

## Prerequisites

 - Ruby
 - Rubygems
 - Bundle

Server side was tested and verified on Linux 4.4.14 (Slackware 14.2) during March 2018 using:

 - ruby 2.3.1p112 (2016-04-26 revision 54768) [x86_64-linux]
 - Rubygems 2.4.8
 - Bundler version 1.15.1

and likewise on Raspbian GNU/Linux 8 during March 2018 using:

 - ruby 2.3.1p112
 - Rubygems 2.6.6
 - Bundler version 1.16.1

Client side was tested and verified with Akregator 4.14.21.


## Download

Download from GitHub repository:

 - 'git clone https://github.com/per-garden/mail2rss.git'.



# Configuration

## Mailman

Adapt files config/environments/development.rb and config/environments/production.rb to your needs. The section specifically regarding mail retrieval is shown below:

```html
  config.mailman = {
    poll_interval: 30,
    pop3: {server: 'pop.googlemail.com', port: 995, ssl: 'true', username: 'USERNAME', password: 'PASSWORD'},
    # Mail into rss from these adresses. Empty list => rss from any sender
    senders: [],
    # Mail into rss with these subjects. Empty list => rss with any subject
    subjects: []
  }
```

Parameters should be reasonably self-explanatory. Which incoming emails go into the rss feed can be restricted.

Mail2rss currently does not support two-way authentication. For google accounts, as in the above sample, this means that "less secure apps" must be allowed. Switch on at https://myaccount.google.com/lesssecureapps for the mail account you are using.


## Rss

As default the rss feed will appear on port 3000, and on the default route, e.g. http://localhost:3000


# Setup

## Gems

Go to directory as created by git clone. Then type:

 - bundle install


## Setting up data

Initiate the database(s):

 - bundle exec rake db:migrate

No data seeding is required. The first email fetched by mail2rss will be stored as a singleton message. Note that there will always only be one single message, based on the most recent email fetched.

Also note that only new emails will be fetched into mail2rss. Mail2rss must be up and running to detect any new emails. Mail received by the configured mail account when mail2rss is not up and running will be disregarded by mail2rss.

Default mail retrieval method is POP3 without leaving a copy on mail server.



# Usage

Be positioned in the mail2rss directory. Then start rails server:

```html
per@lex14:~/projects/mail2rss$ rails s
=> Booting Puma
=> Rails 5.1.5 application starting in development 
=> Run `rails server -h` for more startup options
I, [2018-03-02T11:31:02.842413 #2529]  INFO -- : Mailman v0.7.3 started
I, [2018-03-02T11:31:02.842993 #2529]  INFO -- : POP3 receiver enabled (USERNAME@gmail.com@pop.googlemail.com).
I, [2018-03-02T11:31:02.860305 #2529]  INFO -- : Polling enabled. Checking every 30 seconds.
Puma starting in single mode...
* Version 3.11.2 (ruby 2.3.1-p112), codename: Love Song
* Min threads: 5, max threads: 5
* Environment: development
* Listening on tcp://0.0.0.0:3000
Use Ctrl-C to stop
```

Now access the application at e.g. 'http://my_host.my_domain:3000' (For local testing this will be 'http://localhost:3000')

Stopping:

```html
^C- Gracefully stopping, waiting for requests to finish
=== puma shutdown: 2018-03-02 11:47:37 +0100 ===
- Goodbye!
Exiting
/home/per/projects/mail2rss/config/initializers/mailman_fetcher.rb:7:in `block in <top (required)>': Wait for MailmanFetchJob to finish (RuntimeError)
E, [2018-03-02T11:47:47.774334 #2529] ERROR -- : Couldn't cleanly terminate all actors in 10 seconds!
per@lex14:~/projects/mail2rss$
```

Shutting down reports errors although everything is OK...


# Tests

TODO


# Known Issues and Future Work

 - The most imminent (and before doing anything else) step is to write rspec tests.

 - Neater shutdown, without reported errors.

 - Storing more messages.

 - Managing more than one single rss feed.


# Licence

Copyright (c) 2018 Avalon Innovation AB.

GNU General Public License. See separate licence file for details.
