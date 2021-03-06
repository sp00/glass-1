# Glass

This Gem is meant to help you quickly building application for Google Glass thanks to Ruby.

This gem is based on google/api-client.

Google/api-client is terrible to use. This gem aim to make it softer. 
It offer a simple interface to the Mirror API and manage Auth, credentials and tokens for you.

This gem is using Redis to store clients credentials and token.

## Installation

Add this line to your application's Gemfile:

    gem 'glass'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install glass

## Usage

Setup Credential

```ruby
require 'glass'
Glass::Mirror.client_id = ENV['GLASS_CLIENT_ID']
Glass::Mirror.client_secret = ENV['GLASS_CLIENT_SECRET']
Glass::Mirror.redirect_uri = ENV['GLASS_REDIRECT_URI']
Glass::Mirror.scopes = [ Add requested scopes]
    # Default is 'https://www.googleapis.com/auth/drive.file',
    #            'https://www.googleapis.com/auth/userinfo.profile',
```

You are a Glassware Explorer Now !
Get a way to get the authorization code from user app install. I don't know how for now. If you find let me know !
And do the OAuth trick
```ruby
ok_glass = Glass::Mirror.build_with_code(authorization_code)
```
### Token Persistence

As in OAuth2.0, Google API issue a Refresh_Token the first time you Authorize the client, so you can get new token later.
You need to store this token. Out of the box Glass's Gem use Redis to do it.

Glass use a namespace on your redis. So don't bother about this (even if you can specify one too).

By default, Glass use local redis store (localhost:6379).

You can specify the Redis store this way :

For Heroku/RedisToGo users

```ruby
Glass::Mirror.redis = ENV["REDISTOGO_URL"]
```


## Overview

### Timeline

Let's say you want to tell "Hi" to the user.
Build it and send it.

```ruby
item = Glass::TimelineItem.new()
item.text="Hi"
ok_glass.insert(item)
```

### Subscriptions

Let's say you want to subscribe to location update.
You need to provide a call_back_url, on wich Google will post the datas.

```ruby
subscription = Glass::Subscription.new()
subscription.collection="location"
subscription.call_back_url="https://glassware.herokuapp.com/location_update"
ok_glass.insert(subscription)
```

### Location

There is a quicker way to get Location update
```ruby
Glass::Location.subscribe(ok_glass,call_back_url)
```



## Going Further

As you are a Glassware Explorer you can explore yourself. Access the google/api-client Client this way :
```ruby
ok_glass.client   # Get the discovered Google::API on wich you can make request
```

Have fun ! And please, show me any use. Just send me a tweet : @TheDamFr


### Bypassing Redis

You can bypass Redis. I don't want to know why you would, but you can do it easily.

Just do :
```ruby
Glass::Mirror.no_redis = true # Glass are so sad !
```

Now you need to handle the storage yourself !

```ruby
credentials = Glass::Mirror.get_credentials(authorization_code)

# Store Credentials !

ok_glass = Glass::Mirror.build_client(credentials)
```
That's okay ! (for now)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
