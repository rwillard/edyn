# edyn

This app allows a user to create a message to say hello to a friend at a later time. It's built in Ruby using Sinatra and Sidekiq. 

To add a message you need to send a POST request with valid JSON using curl. The JSON needs to be in the format 

```
{"name":"Test Name", "time":2000000000}
```

Where name is a String and time is an integer in Unix time. The full curl request will be.

```
curl -H "Content-Type: application/json" -X POST -d '{"name":"Test Name","time":2000000000}' https://sheltered-peak-4759.herokuapp.com
```

You can view all of the queued messages via https://sheltered-peak-4759.herokuapp.com/

You can test via curl by changing the JSON to anything, but these are examples.

To test that it checks for time

```
curl -H "Content-Type: application/json" -X POST -d '{"name":"Test Name","wrong":2000000000}' https://sheltered-peak-4759.herokuapp.com
```

To test that it checks for a name

```
curl -H "Content-Type: application/json" -X POST -d '{"wrong":"Test Name","time":2000000000}' https://sheltered-peak-4759.herokuapp.com
```


To test that it checks that name is a string

```
curl -H "Content-Type: application/json" -X POST -d '{"name":123,"time":2000000000}' https://sheltered-peak-4759.herokuapp.com
```

To test that it checks that time is an integer

```
curl -H "Content-Type: application/json" -X POST -d '{"name":"Test Name","time":"Not an integer"}' https://sheltered-peak-4759.herokuapp.com
```

To test that it checks that the time specified is in the future

```
curl -H "Content-Type: application/json" -X POST -d '{"name":"Test Name","time":1000000000}' https://sheltered-peak-4759.herokuapp.com
```

To run locally

```
bundle install
```

```
gem install foreman
```

```
foreman start
```