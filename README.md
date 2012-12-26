[![Build Status](https://travis-ci.org/igor-alexandrov/wiselinks.png?branch=master)](https://travis-ci.org/igor-alexandrov/wiselinks)
[![Dependency Status](https://gemnasium.com/igor-alexandrov/wiselinks.png)](https://gemnasium.com/igor-alexandrov/wiselinks)
[![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/igor-alexandrov/wiselinks)

#Wiselinks

Wiselinks makes following links and submitting some forms in your web application faster. 

You may find Wiselinks similar to [Turbolinks](https://github.com/rails/turbolinks) or [Pjax](https://github.com/defunkt/jquery-pjax), but Wiselinks have several rather important differences from both projects. We tried to make Wiselinks as easy to use as Turbolinks are but also as configurable as Pjax.

##Compatibility

Wiselinks uses [History.js](https://github.com/balupton/History.js/) library to perform requests.

Wiselinks works in all major browsers including browsers that do not support HTML History API out of the box.

## In Comparison to Turbolinks

<table>
	<thead>
		<tr>
			<th></th>
			<th>Turbolinks</th>
			<th>Wiselinks</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>Work in browsers with History API</td>
			<td>Yes</td>
			<td><strong>Yes</strong></td>
		</tr>
		<tr>
			<td>Work in browsers without History API</td>
			<td>No, degrades to normal request processing.</td>
			<td><strong>Yes</strong></td>
		</tr>
		<tr>
			<td>Work without JavaScript</td>
			<td>No, degrades to normal request processing.</td>
			<td>No, degrades to normal request processing.</td>
		</tr>
		<tr>
			<td>Form processing</td>
			<td>No</td>
			<td><strong>Yes</strong></td>
		</tr>
		<tr>
			<td>Form parameters optimization</td>
			<td>No</td>
			<td><strong>Yes</strong></td>
		</tr>
		<tr>
			<td>Assets change detection</td>
			<td>Yes, by parsing document head on every request.</td>
			<td><strong>Yes</strong>, by calculating assets MD5 hash on boot.</td>
		</tr>
	</tbody>
</table>

##Installation

Add this to your Gemfile:

```ruby
gem 'wiselinks'
```

Then do:
	
	bundle install

Restart your server and you're now using wiselinks!

## How does it work?

Modify your `application.js.coffee` file to use Wiselinks object:
	
```coffeescript	
#= require jquery
#= require wiselinks

$(document).ready ->
    window.wiselinks = new Wiselinks()
```	

And finally you should tell Wiselinks to process your links or forms.

Links will fire History.pushState() event.
Data from the request will replace content of the container that was passed to Wiselinks (default is "body")


```html	
<ul class="menu">
    <li>
	    <a href="/" data-push="true">Home</a>
    </li>	
    <li>
   		<a href="/contacts" data-push="true">Contacts</a>
    </li>
</ul>
```

Link will fire History.replaceState() event.
Data from the request will replace content of the container that was passed to Wiselinks (default is "body")

```html
<div class="dialog">
	<a href="/step2" data-replace="true">Proceed to the next step</a>
</div>	
```

Links will fire History.pushState() event.
Data from the request will be pasted into `<div role="catalog">`. This configuration is widely when you have list of items that are paginated, sorted or maybe grouped by some attributes and you want to update only these items and nothing more on page.

```html	
<ul class="pagination">
    <li>
	    <span>1</span>
    </li>	
    <li>
   		<a href="/?page=2" data-push="true" data-target="@catalog">2</a>
    </li>
    <li>
   		<a href="/?page=3" data-push="true" data-target="@catalog">3</a>
    </li>
    <li>
   		<a href="/?page=4" data-push="true" data-target="@catalog">4</a>
    </li>
</ul>
<ul class="sort">
	<li>
	    <a href="/?sort=title" data-push="true" data-target="@catalog">Sort by Title</a>
    </li>	
    <li>
   		<a href="/?sort=price" data-push="true" data-target="@catalog">Sort by Price</a>
    </li>	
</ul>

<div role="catalog">
	<!-- the list of your items -->
	...
</div>
```

**You can use Wiselinks with forms**! As easy and clear as with links. After submit button is clicked, Wiselinks will perform a request to "/" with serialized form attributes. The result of this request will be pasted into `<div role="catalog">`.

```html	
<div class="filter">
    <form action="/" method="get" data-push="true" data-target="@catalog">
		<input type="text" size="30" name="title" id="title">
		
		<select name="scope" id="scope">
			<option value="">All Tax Liens</option>
			<option value="accruing">Accruing Interest</option>
          	<option value="awaiting_payment">Awaiting Payment</option>
          	<option value="closed">Closed</option>
          	<option value="trashed">Trash</option>
    	</select>
    	
		<input type="submit" value="Find" name="commit">		
    </form>
</div>    

<div role="catalog">
	<!-- the list of your items -->
	...
</div>
```

You can add some options, if you want:

```coffeescript	
#= require jquery
#= require jquery.role
#= require wiselinks

$(document).ready ->
    # DOM element with role = "content" will be replaced after data load.    	
    window.wiselinks = new Wiselinks($('@content'))
    
	# Of course you can use more traditional jQuery selectors.
	# window.wiselinks = new Wiselinks($('#content'))
	# window.wiselinks = new Wiselinks($('.content:first'))

	$(document).off('page:loading').on(
        'page:loading'
        (event, url, target, render) ->        
            console.log("Wiselinks loading: #{url} to #{target} within '#{render}'")
            # start loading animation
    )

	$(document).off('page:complete').on(
        'page:complete'
        (event, xhr, settings) ->
            console.log("Wiselinks page loading completed")
            # stop loading animation
    )

    $(document).off('page:success').on(
        'page:success'
        (event, data, status) ->        
            console.log("Wiselinks status: '#{status}'")
    )

    $(document).off('page:error').on(
        'page:error'
        (event, data, status) ->        
            console.log("Wiselinks status: '#{status}'")
            # show error message
    )
```     	

## Javascript Events

While using Wiselinks you **can rely** on `DOMContentLoaded` or `jQuery.ready()` to trigger your JavaScript code, but Wiselinks gives you some additional useful event to deal with the lifecycle of the page:

### page:loading (url, target, render = 'template')

Event is triggered before the `XMLHttpRequest` is initialised and performed.
* *url* - URL of the request that will be performed;

* *target* – element of the page where result of the request will be loaded into;

* *render = 'template'* – what should be rendered; can be 'template' or 'partial';

### page:success (data, status) ###

Event is triggered if the request succeeds.
* *data* – the data returned from the server;

* *status* – a string describing the status;

### page:error (status, error) ###

Event is triggered if the request fails.

* *status* – a string describing the type of error that occurred;
* *error* – optional exception object, if one occurred;

So if you wanted to have a client-side spinner, you could listen for `page:loading` to start it and `page:success` or `page:error` to stop it.

## ActionDispatch::Request extensions

Wiselinks adds a couple of methods to `ActionDispatch::Request`. These methods are mostly syntax sugar and don't have any complex logic, so you can use them or not.

### #wiselinks? ###
Method returns `true` if current request is initiated by Wiselinks, `false` otherwise. 

### #wiselinks_template? ###
Method returns `true` if current request is initiated by Wiselinks and client want to render template, `false` otherwise. 

### #wiselinks_partial? ###
Method returns `true` if current request is initiated by Wiselinks and client want to render partial, `false` otherwise. 

## Assets change detection

You can enable assets change detection with Wiselinks. To do this you have to enable assets digests by adding this to you environment file:

```ruby
config.assets.digest = true
```

Then you should append your layout by adding this to head section:

```erb
<%= wiselinks_meta_tag %>
```

Now Wiselinks will track changes of your assets and if anything will change, your page will be reloaded completely.

## Title handling

Wiselinks handles page titles by passing `X-Title` header with response. To do this you can use `wiselinks_title` helper.

```html	
<% wiselinks_title("Wiselinks is awesome") %>

<div>
	<!-- your content -->
	...
</div>
```

Of course you can use `wiselinks_title` helper in your own helpers too.

##Example

We crafted example application that uses nearly all features of Wiselinks so you can see it in action.

* GitHub Repository: [https://github.com/igor-alexandrov/wiselinks_example](https://github.com/igor-alexandrov/wiselinks_example)

* Live Example: [http://wiselinks.herokuapp.com/](http://wiselinks.herokuapp.com/)

## Note on Patches / Pull Requests

* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but
   bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

## Credits

![JetRockets](http://www.jetrockets.ru/images/logo.png)

Wiselinks is maintained by [JetRockets](http://www.jetrockets.ru).

Contributors:

* [Igor Alexandrov](http://igor-alexandrov.github.com/)
* [Alexey Solilin](https://github.com/solilin)
* [Julia Egorova](https://github.com/vankiru)

## License

It is free software, and may be redistributed under the terms specified in the LICENSE file.

	