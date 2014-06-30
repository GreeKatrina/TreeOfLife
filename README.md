Tree of Life
==========

Tree of Life is a data visualization app that allows people to click through a tree, using Infovis - a Javascript toolkit, using the Tree of Life API.

## Authors

Katrina Theodosopoulos
+ Email: katrinaelaine6@mgail.com
+ Twitter: http://twitter.com/greekatrina
+ GitHub: https://github.com/greekatrina

Ashley McKemie

## Development

+ Ruby 2.1.1.
+ Sinatra
+ ActiveRecord
+ Postgres
+ WikiWhat
+ Infovis (JIT)

## Clone Down Our Repo

First, move to the folder you want the repo to be in, then clone it down and bundle install all of the gems.

```
$ cd /the/folder/you/choose
$ git clone https://github.com/GreeKatrina/TreeOfLife.git
$ bundle install
```
Second, create the database, migrate, and then seed the database with the Tree Of Life JSON file.

```
$ rake db:create
$ rake db:migrate
$ rake setup:seed_database
```
