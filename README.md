# Mailigen
Wrapper for `mailigen.com` API.

## Installation

```rb
gem 'mailigen',
  git: 'https://github.com/CreativeGS/mailigen',
  tag: 'v0.2.3'
```

## Usage
Instantiate Mailigen::Api and use `#call` method.  
First param - API method, second param - parameters (api_key included by default).

Examples:

```rb
require "mailigen"

# initialize(api_key, secure=false, verbose=false) 
mailigen = Mailigen::Api.new(YOUR_MAILIGEN_API_KEY, true, false)

# Ping to check apy key
mailigen.call(:ping) # returns "Everything's Ok!" if API KEY is correct

# Create a list
list_id = mailigen.call(:listCreate, {title: "testListRspec", options: {permission_reminder: "Your in", notify_to: "foo@bar.com", subscription_notify: false}})

# Add extra var to list
mailigen.call(:listMergeVarAdd, {id: list_id, tag: "NAME", name: "Name of user"})

# Add contacts batch to list
contacts_array_hash = {
  "0" => {EMAIL: "foo@sample.com", EMAIL_TYPE: 'plain', NAME: 'Foo'},
  "1" => {EMAIL: "bar@sample.com", EMAIL_TYPE: 'html',  NAME: 'Bar'},
  "2" => {EMAIL: "foo@sample.com", EMAIL_TYPE: 'html',  NAME: 'Foo Dublicate'}
}

resp = mailigen.call(:listBatchSubscribe, {id: list_id, batch: contacts_array_hash, double_optin: false})

puts resp["success_count"] #=> 3
```

Discover more API methods in the [official documentation](http://dev.mailigen.com/functions)

## Testing
Gem uses Webmocked RSpec. No remote requests are made, API v1.5 responses have been captured and are replayed in tests.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
