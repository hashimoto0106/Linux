#!/usr/local/bin/ruby


# gem install twitter oauth

require 'twitter'
require 'oauth'
require 'json'

# Oauth認証
# Twitterから取得したAPIキーを入れてください。
consumer_key = 'your_consumer_key'
consumer_secret = 'your_consumer_secret'
access_key = 'your_access_key'
access_secret = 'your_access_secret'

consumer = OAuth::Consumer.new(
  consumer_key,
  consumer_secret,
  site:'https://api.twitter.com'
)
endpoint = OAuth::AccessToken.new(consumer, access_key, access_secret)

# paramsに、パラメータを付与
# https://dev.twitter.com/overview/documentation
response = endpoint.request(:get, 'https://api.twitter.com/1.1/statuses/user_timeline.json?{params}')
json_obj =  JSON.parse(response.body)
puts JSON.generate(json_obj)
