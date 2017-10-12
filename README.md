# Dash

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/dash`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'dash'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install dash

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/dash. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Setup

Run the setup rake task

```
rails dash:install
```

### Migrations

Copy migrations for notifications to your app and then run rails db:migrate
```
rails railties:install:migrations
```
### Environment Config

#### Production

```
config.action_mailer.delivery_method = :mandrill
```

### Secrets

```
slack_bot_username: mybotname
slack_notification_webhook: http://webhook
slack_enabled: 1
mandrill_api_key:
myadventist_client_id:
myadventist_client_secret:
myadventist_redirect_uri:
google_browser_key:
```


## Features

### Exporting

Table data can be exported to CSV easily by create an exporter.

The exporter by default should be [model_name]_exporter.rb

```
/app/exporters/user_exporter.rb

class UserExporter < DashExporter
  attributes :id, :first_name, :last_name
end
```

To export all table columns, pass the attributes as ```*User.column_names```

In a controller you can call the exporter like so

```
respond_to do |format|
  format.csv { send_data @users.to_csv, filename: "users-export.csv" }
end
```

You can create custom exporters although you'll need to call the exporter directly from the controller.

```
respond_to do |format|
  format.csv { send_data CustomUserExporter.new(@users).to_csv, filename: "users-export.csv" }
end
```
## Using Maps

### HTML Markup

```
<%= content_tag(:div, "", style: "height:250px;", class: "map-canvas", data: {zoom: 15, drag_callback: "mapCardDragCallback", bounds_callback: "mapCardBoundsCallback", markers: [{draggable: true, lat: -33.0, lng: 151.0, content_callback: "mapContentCallback"}].to_json}) %>
```

### Example JS callbacks

```
// Maps
function mapCardDragCallback(googleMap, newLatLng){
  $('.lat').val( newLatLng.lat() );
  $('.lng').val( newLatLng.lng() );
}

function mapCardBoundsCallback(googleMap){
  $('.zoom').val( googleMap.map.getZoom() );
}
function mapContentCallback(marker){
  return marker.title;
}
function addressMapSearchCallback(results){
  if(results.length > 0){
    var googlemap = $('.map-canvas').data('googlemap');
    if(googlemap){
      googlemap.moveMarker(googlemap.markers[0], results[0]);
    }
  }
  else{
    alert("Address was not found.");
  }
}
$(document).on('click', '.map-address-search', function(e){
  e.preventDefault();
  var address = $('.map-address-field').val();
  addressMapSearch( { 'address': address }, "addressMapSearchCallback" );
})
```


## HTML

### Team Nav

```
<div class="team-nav">
  <div class="wrapper">
    <div class="team-nav-content">
      <div class="avatar">
        <%= image_tag "https://site.com/avatar_blue.jpg" %>
      </div>
      <div class="content">
        <span class="name">Wahroonga Church</span>
      </div>
      <%= link_to content_tag(:i, "", class: "fa fa-angle-down"), "#", class: "team-toggle" %>
    </div>
    <ul class="team-list nav-group">
      <li><%= link_to content_tag(:i, "", class: "fa fa-fort-awesome icon").html_safe + "Fox Valley Church", "#", class: "nav-group-item" %></li>
      <li><%= link_to content_tag(:i, "", class: "fa fa-fort-awesome icon").html_safe + "3am Church", "#", class: "nav-group-item" %></li>
    </ul>
  </div>
</div>
```