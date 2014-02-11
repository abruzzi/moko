### Moko

Moko is used to generate configuration for [moco](https://github.com/dreamhead/moco), and it let you define a `RESTFul` API in seconds(or minutes).

#### Setup
```sh
$ rake moko:init
```

This task will try to download the latest version of moco(the server used underlying of moko [moco](https://github.com/dreamhead/moco)) to your local environment: `moco` in current directory.

If you have already used `moco`, simply rename it to `moco-runner-standalone.jar`, and move it to directory `moco/`(that's where `moko` will look for it).

That's it.

#### Define a resource

To define your resources in `moko`, the simplest way is using `resources` method in `moko.rb`. That's pretty strightforward:

```ruby
Moko::Server.draw do
	resources :users
end
```

and then run `moko:server` to launch `moco` server:

```sh
$ rake moko:server
```

and you will see some thing like:

```sh
java -jar ./moco/moco-runner-standalone.jar start -p 12306 -c conf/moko.conf.json
12 Feb 2014 00:16:31 [main] INFO  Server is started at 12306
12 Feb 2014 00:16:31 [main] INFO  Shutdown port is 51127
```

then you can use those resources freely just as they are really defined in the backend:

```sh
curl -X POST -d "{}" http://localhost:12306/users
```

or 

```sh
curl http://localhost:12306/users/23
```

And of course you can define many resources:

```ruby
Moko::Server.draw do
	resources :users
    resources :posts 
    resources :comments
end
```

or 

```ruby
Moko::Server.draw do
    resources :users, :posts, :comments
end
```

#### Resource With data

Ok, the example above is boring I would say, but you can define some more intesting stuff, like this one:

```ruby
Moko::Server.draw do
    resource :user do |u|
        u.string :name
        u.integer :age
        u.string :type
        u.datetime :created_at
        u.datetime :updated_at
    end
end
```

and run the `rake moko:server` again. This time, the response will be more meaningful:

```sh
$ curl -X POST -d "{}" http://localhost:12306/users | jq .
```

and you'll get the following as expected:

```json
{
  "updated_at": "2014-02-12 00:16:29 +1100",
  "created_at": "2014-02-12 00:16:29 +1100",
  "type": "defaultStringValue",
  "arg": 1,
  "name": "defaultStringValue"
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

when arriving request is matching `/users/\\d+`(regular expression here matches an number as ID), the response will be returned, in `json` format, with data stored in `resources/users.json`. 

Of cource, the schema of the content of `resources/users.json` is defined in `moko.rb`.

Pretty simple!

#### What's next

Maybe we can add `namespace` or nested resources to `moko`, or we can make the data make more sense. Any suggestions are more than welcomed.

