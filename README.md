# README

You will find the code of the server for our *Designing Interactive Systems II* game [Don't cross the streams](http://dncts.blogspot.de) here. The API for this server can be found [here](https://github.com/moonglum/dncts/wiki/API).

## Running the server

* Make sure you've installed Ruby on your system
* `cd` into this folder, run `gem install bundler`
* Run `bundle`
* Start Redis via `redis-server`
* Start our server via `bundle exec rackup -s thin`
* The server is now running on 9292

## License

The code in this repository is published under the MIT license. Have fun with it.
