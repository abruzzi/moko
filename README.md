### Moko

`Moko` is used to generate configuration for [moco](https://github.com/dreamhead/moco), and it allows you to define `RESTFul` API(s) in seconds.

#### Install

```sh
$ gem install 'moko'
```

or put this `gem 'moko'` in your Gemfile. 

After the installation, you can use command `mokoup` shipped with moko to setup your RESTFul API.

```sh
➜  moko git:(master) ✗ mokoup help
Commands:
  mokoup generate        # generate moco configuration and restful resources
  mokoup help [COMMAND]  # Describe available commands or one specific command
  mokoup server          # startup the underlying moco server
```

There are 2 commands available currently, `generate` and `server`. `generate` command looks for a file named `moko.up` in your current directory, and use it to generate configuration for underlying `moco` server. And `server` command used to launch the `moco` server.

```sh
$ moco server
```

will first try to download the latest moco first, and then launch it at port `12306`.

#### Define a resource

To define your resources in `moko`, the simplest way is by using `resources` method in file `moko.up`. That's pretty strightforward:

```ruby
resources :users
```

and then run `mokoup generate` to generate resources, this will generate a configuration for `moco`: `conf/moco.conf.json`, and the corresponding resources in `resources` directory, of course it's empty in this case.

After that, you can launch the moco server by 
```sh
$ mokoup server
```

and then you can get something like this:

```sh
run  java -jar /Users/twer/.rvm/gems/ruby-1.9.3-p448/gems/moko-0.1.0/bin/moco/moco-runner-standalone.jar start -p 12306 -c conf/moko.conf.json from "."

22 Feb 2014 19:47:38 [main] INFO  Server is started at 12306
22 Feb 2014 19:47:38 [main] INFO  Shutdown port is 56731
```

Since the server is up and running, you can use those resources freely just as they are really defined in the backend server (Rails, Php, Java...):

For example, you can use curl to test those APIs:

```sh
curl -X POST -d "{}" http://localhost:12306/users
```

or 

```sh
curl http://localhost:12306/users/23
```

And of course you can define many resources at a time:

```ruby
resources :users
resources :posts 
resources :comments
```

or 

```ruby
resources :users, :posts, :comments
```

#### Resource With data

Ok, the example above is boring I would say, but you can actually define some more intesting stuff, like this:

```ruby
resource :user do |u|
    u.string :name
    u.integer :age
    u.string :type
    u.datetime :created_at
    u.datetime :updated_at
end
```

and run the `mokoup generate && mokoup server` again. This time, the response will be more meaningful:

```sh
$ curl -X POST -d "{}" http://localhost:12306/users | jq .
```

and you'll get the following as expected:

```json
{
  "updated_at": "2014-02-12 00:16:29 +1100",
  "created_at": "2014-02-12 00:16:29 +1100",
  "type": "default String Value",
  "arg": 1,
  "name": "default String Value"
}
```

#### Under the hood

Basically, `moko` just use some magics from ruby meta programming, and generate a configuration which will be used by `moco` in file `conf/moko.conf.json`. 

That file defined some rules of how a request should be responeded:

```json
...
{
    "request": {
        "method": "get",
        "uri": {
            "match": "/users/\\d+"
        }
    },
    "response": {
        "status": 200,
        "headers" : {
            "content-type" : "application/json"
        },        
        "file": "resources/users.json"
    }
}
...
```

when arriving request is matching `/users/\\d+`(regular expression here matches an number as ID), the response will be returned, in `json` format, with data stored in `resources/users.json`. And the schema of the content of `resources/users.json` is defined in `moko.up`.

Pretty simple, right!

#### What's next

Maybe we can add `namespace` or nested resources to `moko`, or we can make the data make more sense. Any suggestions are more than welcomed.
