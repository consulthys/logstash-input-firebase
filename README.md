# Logstash Firebase Input Plugin

This is an input plugin for [Logstash](https://github.com/elastic/logstash).

It is fully free and fully open source. The license is Apache 2.0, meaning you are pretty much free to use it however you want in whatever way.

## Documentation

The [Firebase](https://firebase.google.com) input plugin retrieves data from the Firebase real-time 
database [via the REST API](https://firebase.google.com/docs/database/rest/retrieve-data). It is based on the excellent 
[rest-firebase](https://github.com/CodementorIO/rest-firebase) Ruby library by the [Codementor](https://www.codementor.io) folks.
Each `firebase` input allows you to retrieve as many references as desired from a single Firebase database.

This input plugin can work in two modes:
 1. Retrieve the value of database references on a fixed `schedule` (at midnight, every 5 minutes, etc)
 2. Retrieve the value of database references in real-time as it changes 
 (via the [streaming REST API](https://firebase.google.com/docs/database/rest/retrieve-data#section-rest-streaming)). 
 Firebase will push events to Logstash as they occur. Note that to use this mode, the `schedule` setting must be omitted. 

The retrieved data will be stored at the event root level by default (unless the `target` field is configured).

It can be configured very simply as shown below: 
```
input {
  firebase {
    url => "https://test.firebaseio.com"
    auth => "secret"
    # Supports "cron", "every", "at" and "in" schedules by rufus scheduler
    schedule => { cron => "* * * * * UTC"}
    # A hash of request metadata info (timing, response headers, etc.) will be sent here
    metadata_target => "@meta"
    refs => {
      user_details => {
        path => "/user/details"
      }
      company_orders => {
        path => "/company/orders"
        orderBy => "$key"
        limitToFirst => 3
      }
    }
  }
}
output {
  stdout {
    codec => rubydebug
  }
}
```

Here is how a sample event will look like:

```
{
                    "id" => 123,
            "first_name" => "James",
             "last_name" => "Smith",
                   "age" => 20,
            "@timestamp" => 2017-01-11T17:27:01.238Z,
              "@version" => "1",
                  "tags" => []
               "friends" => {
  "-KXqY-9NlfAn5GNJfEgy" => {
                    "id" => "1",
                  "name" => "John"
  },
  "-KXq_9OSs-nEQO_X1kRw" => {
                    "id" => "2",
                  "name" => "Jane"
  }
               },
                 "@meta" => {
                  "host" => "iMac.local",
                 "event" => "get"
            "query_name" => "user_details",
       "runtime_seconds" => 1.106,
            "query_spec" => {
                  "path" => "/user/details"
            },
    }
}
```

### Configuration

The following list enumerates all configuration parameters of the `firebase` input:

 * `url`: (required)The Firebase URL endpoint
 * `secret`: (optional) The secret to use for authenticating
 * `schedule`: (optional) the [schedule specification](#scheduling) determining when the `firebase` input must run (see below for details)
   This setting must be omitted in order to use the streaming mode.
 * `target`: (optional) the name of the field into which to store the retrieved data (default: root)
 * `metadata_target`: (optional) the name of the field into which to store some metadata about the call (default: `@metadata`)
 * `events`: the set of streaming events to listen to (possible values are `put`, `patch`, `keep-alive`, `cancel`, `auth_revoked) (default: `['put', 'patch']`) 
 * `refs`: Any number of named queries mapped to a hash with the following parameters: (at least one required)
   * `path`: the database reference to query
   * `orderBy`: (not supported yet)
   * `limitToFirst`: (not supported yet) 

### Scheduling

This plugin can also be scheduled to run periodically according to a specific
schedule. This scheduling syntax is powered by [rufus-scheduler](https://github.com/jmettraux/rufus-scheduler).
The syntax is cron-like with some extensions specific to Rufus (e.g. timezone support ).

Examples:

```
* 5 * 1-3 *               | will execute every minute of 5am every day of January through March.
0 * * * *                 | will execute on the 0th minute of every hour every day.
0 6 * * * America/Chicago | will execute at 6:00am (UTC/GMT -5) every day.
```

Further documentation describing this syntax can be found [here](https://github.com/jmettraux/rufus-schedulerparsing-cronlines-and-time-strings).

## Need Help?

Need help? Try #logstash on freenode IRC or the https://discuss.elastic.co/c/logstash discussion forum.

## Developing

### 1. Plugin Developement and Testing

#### Code
- To get started, you'll need JRuby with the Bundler gem installed.

- Create a new plugin or clone and existing from the GitHub [logstash-plugins](https://github.com/logstash-plugins) organization. We also provide [example plugins](https://github.com/logstash-plugins?query=example).

- Install dependencies
```sh
bundle install
```

#### Test

- Update your dependencies

```sh
bundle install
```

- Run tests

```sh
bundle exec rspec
```

### 2. Running your unpublished Plugin in Logstash

#### 2.1 Run in a local Logstash clone

- Edit Logstash `Gemfile` and add the local plugin path, for example:
```ruby
gem "logstash-filter-awesome", :path => "/your/local/logstash-filter-awesome"
```
- Install plugin
```sh
bin/logstash-plugin install --no-verify
```
- Run Logstash with your plugin
```sh
bin/logstash -e 'filter {awesome {}}'
```
At this point any modifications to the plugin code will be applied to this local Logstash setup. After modifying the plugin, simply rerun Logstash.

#### 2.2 Run in an installed Logstash

You can use the same **2.1** method to run your plugin in an installed Logstash by editing its `Gemfile` and pointing the `:path` to your local plugin development directory or you can build the gem and install it using:

- Build your plugin gem
```sh
gem build logstash-filter-awesome.gemspec
```
- Install the plugin from the Logstash home
```sh
bin/logstash-plugin install /your/local/plugin/logstash-filter-awesome.gem
```
- Start Logstash and proceed to test the plugin

## Contributing

All contributions are welcome: ideas, patches, documentation, bug reports, complaints, and even something you drew up on a napkin.

Programming is not a required skill. Whatever you've seen about open source and maintainers or community members  saying "send patches or die" - you will not see that here.

It is more important to the community that you are able to contribute.

For more information about contributing, see the [CONTRIBUTING](https://github.com/elastic/logstash/blob/master/CONTRIBUTING.md) file.
