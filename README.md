[![Build Status](https://travis-ci.org/igor-alexandrov/wiselinks.png)](https://travis-ci.org/igor-alexandrov/wiselinks)
[![Code Climate](https://codeclimate.com/github/igor-alexandrov/wiselinks.png)](https://codeclimate.com/github/igor-alexandrov/wiselinks)
[![Coverage Status](https://coveralls.io/repos/igor-alexandrov/wiselinks/badge.png)](https://coveralls.io/r/igor-alexandrov/wiselinks)
[![Dependency Status](https://gemnasium.com/igor-alexandrov/wiselinks.png)](https://gemnasium.com/igor-alexandrov/wiselinks)
[![Gem Version](https://badge.fury.io/rb/wiselinks.png)](http://badge.fury.io/rb/wiselinks)


#Wiselinks

Wiselinks makes following links and submitting forms in your web application faster.

You may find Wiselinks similar to [Turbolinks](https://github.com/rails/turbolinks) or [Pjax](https://github.com/defunkt/jquery-pjax), but Wiselinks works as a whitelist rather than blacklist. We tried to make Wiselinks as easy to use as Turbolinks are but also as configurable as Pjax.

Try Wiselinks online in our **demo application**:

 * [http://wiselinks.herokuapp.com/](http://wiselinks.herokuapp.com/)

## Compatibility

**Please be advised that Javascript events in wiselinks-0.5.0 are not backward compatible.**

Wiselinks uses [History.js](https://github.com/balupton/History.js/) library to perform requests.

Wiselinks works in all major browsers including browsers that do not support HTML History API out of the box.

## In Comparison to Turbolinks and PJAX

<table>
	<thead>
		<tr>
			<th></th>
			<th>Wiselinks</th>
			<th>Turbolinks</th>
			<th>PJAX</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>Work in HTML5 browsers</td>
			<td><strong>Yes</strong></td>
			<td>Yes</td>
			<td>Yes</td>
		</tr>
		<tr>
			<td>Work in browsers without History API</td>
			<td><strong>Yes</strong>, with hashbang (can be switched off)</td>
			<td>No, degrades to normal request processing</td>
			<td>No, degrades to normal request processing</td>
		</tr>
		<tr>
			<td>Work without JavaScript</td>
			<td>No, degrades to normal request processing</td>
			<td>No, degrades to normal request processing</td>
			<td>No, degrades to normal request processing</td>
		</tr>
		<tr>
			<td>Form processing</td>
			<td><strong>Yes</strong></td>
			<td>No</td>
			<td>Yes (experimental feature)</td>
		</tr>
		<tr>
			<td>Form blank values exclusion</td>
			<td><strong>Yes</strong> (optional)</td>
			<td>No</td>
			<td>No</td>
		</tr>
		<tr>
			<td>Form values optimization</td>
			<td><strong>Yes</strong></td>
			<td>No</td>
			<td>No</td>
		</tr>
		<tr>
			<td>Assets change detection</td>
			<td><strong>Yes</strong>, by calculating assets MD5 hash on boot</td>
			<td>Yes, by parsing document head on every request</td>
			<td>Yes, manually</td>
		</tr>
		<tr>
			<td>30x HTTP redirects processing</td>
			<td><strong>Yes</strong></td>
			<td>No</td>
			<td>Yes</td>
		</tr>
	</tbody>
</table>

##Installation

### Rails

Add this to your Gemfile:

```ruby
gem 'wiselinks'
```

Then do:

	bundle install

Restart your server and you're now using wiselinks!

### All others

Copy `wiselinks-x.y.z.js` or `wiselinks-x.y.z.min.js` from `build` folder in this project to your project.

## How does it work?

### CoffeeScript

Create Wiselinks object in your `application.js.coffee`:

```coffeescript
#= require jquery
#= require wiselinks

$(document).ready ->
    window.wiselinks = new Wiselinks()
```

You can disable HTML4 browsers support easily:

```coffeescript
#= require jquery
#= require wiselinks

$(document).ready ->
    window.wiselinks = new Wiselinks($('body'), html4: false )
```


Or you can add some more options, if you want:

```coffeescript
#= require jquery
#= require jquery.role
#= require wiselinks

$(document).ready ->
    # DOM element with id = "content" will be replaced after data load.
    window.wiselinks = new Wiselinks($('#content'))

	$(document).off('page:loading').on(
        'page:loading'
        (event, $target, render, url) ->
            console.log("Loading: #{url} to #{$target.selector} within '#{render}'")
            # code to start loading animation
    )

	$(document).off('page:redirected').on(
        'page:redirected'
        (event, $target, render, url) ->
            console.log("Redirected to: #{url}")
            # code to start loading animation
    )

	$(document).off('page:always').on(
        'page:always'
        (event, xhr, settings) ->
            console.log("Wiselinks page loading completed")
            # code to stop loading animation
    )

    $(document).off('page:done').on(
        'page:done'
        (event, $target, status, url, data) ->
            console.log("Wiselinks status: '#{status}'")
    )

    $(document).off('page:fail').on(
        'page:fail'
        (event, $target, status, url, error, code) ->
            console.log("Wiselinks status: '#{status}'")
            # code to show error message
    )
```

### HTML

Click on links with `data-push` attribute will fire History.pushState() event.
Data from the request will replace content of the container that was passed to Wiselinks (default is `$('body')`)


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

Click on links with `data-replace` will fire History.replaceState() event.
Data from the request will replace content of the container that was passed to Wiselinks (default is "body")

```html
<div class="dialog">
	<a href="/step2" data-replace="true">Proceed to the next step</a>
</div>
```

Click on following links will fire History.pushState() event.
Data from the request will be pasted into `<div id="catalog">`. This configuration is widely when you have list of items that are paginated, sorted or maybe grouped by some attributes and you want to update only these items and nothing more on page.

```html
<ul class="pagination">
    <li>
	    <span>1</span>
    </li>
    <li>
   		<a href="/?page=2" data-push="true" data-target="#catalog">2</a>
    </li>
    <li>
   		<a href="/?page=3" data-push="true" data-target="#catalog">3</a>
    </li>
    <li>
   		<a href="/?page=4" data-push="true" data-target="#catalog">4</a>
    </li>
</ul>

<ul class="sort">
	<li>
	    <a href="/?sort=title" data-push="true" data-target="#catalog">Sort by Title</a>
    </li>
    <li>
   		<a href="/?sort=price" data-push="true" data-target="#catalog">Sort by Price</a>
    </li>
</ul>

<div id="catalog">
	<!-- the list of your items -->
	...
</div>
```

**Form processing**

Wiselinks can process forms. After submit button is clicked, Wiselinks will perform a request to form url with form attributes serialized to a string. Wiselinks always performs a HTTP GET request.

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
**data-include-blank-url-params**

During form submit Wiselinks excludes blank parameters to make your URLs cleaner. You can disable this behaviour with ```data-include-blank-url-params``` attribute.

```html
<div class="filter">
    <form action="/" method="get" data-push="true" data-target="@catalog" data-include-blank-url-params="true">
		<input type="text" size="30" name="title" id="title">
		<input type="submit" value="Find" name="commit">
    </form>
</div>
```

**data-optimize-url-params**

Array parameters ```category_ids[]=1&category_ids[]=2&category_ids[]=3``` are optimized to more human readable ```category_ids=1,2,3```. To changed this behaviour use ```data-optimize-url-params``` attribute.

```html
<div class="filter">
    <form action="/" method="get" data-push="true" data-target="@catalog" data-optimize-url-params="false">
		<input type="text" size="30" name="title" id="title">
		<input type="submit" value="Find" name="commit">
    </form>
</div>
```


### Server processing

The idea of Wiselinks is that you should render only content that you need in current request. Usually you don't need to reload your stylesheets and javascripts on every request.

`X-Wiselinks` header is passed with every Wiselinks request. Server should respond with content that should be inserted into `$target`.

In Rails after installing Wiselinks gem, all requests that have `X-Wiselinks` header will be automatically processed within 'app/views/layouts/wiselinks' layout, that basically has only `yield` operator. Of course you can override layout name by redefining `wiselinks_layout` method in your controller.

### Javascript Events

While using Wiselinks you **can rely** on `DOMContentLoaded` or `jQuery.ready()` to trigger your JavaScript code, but Wiselinks gives you some additional useful event to deal with the lifecycle of the page:

**page:loading ($target, render, url)**

Event is triggered before the `XMLHttpRequest` is initialised and performed.
* *$target* – JQuery object in which result of the request will be inserted;

* *url* - URL of the request that will be performed;

* *render* – what should be rendered; can be 'template' or 'partial';

**page:redirected ($target, render, url, xhr)**

Event is triggered when you were redirected during `XMLHttpRequest` (with HTTP 30x status).
* *$target* – jQuery object in which result of the request will be inserted;

* *url* - URL where you have been redirected to;

* *render* – what should be rendered; can be 'template' or 'partial';

* *xhr* – the jqXHR object, which is a superset of the XMLHTTPRequest object;

**page:done ($target, status, url, data, xhr)**

Event is triggered if the request succeeds.
* *$target* – jQuery object that was updated with the request;

* *status* – a string describing the status;

* *url* – url of the request;

* *data* – content of the request;

* *xhr* – the jqXHR object, which is a superset of the XMLHTTPRequest object;

**page:fail ($target, status, url, error, code, xhr)**

Event is triggered if the request fails.

* *$target* – jQuery object that had to be updated with the request;

* *status* – a string describing the status;

* *url* – url of the request;

* *error* – a string describing the type of error that occurred;

* *code* – HTTP response status code

* *xhr* – the jqXHR object, which is a superset of the XMLHTTPRequest object;

**page:always ($target, status, url)**

Event is triggered after each request.

* *$target* – jQuery object that had to be updated with the request;

* *status* – a string describing the status;

* *url* – url of the request;

So if you want to show a client-side loading spinner, you could listen for `page:loading` to start it and `page:always` to stop it.

### ActionDispatch::Request extensions

Wiselinks adds a couple of methods to `ActionDispatch::Request`. These methods are mostly syntax sugar and don't have any complex logic, so you can use them or not.

#### #wiselinks? ###
Method returns `true` if current request is initiated by Wiselinks (has `X-Wiselinks` header), `false` otherwise.

#### #wiselinks_template? ###
Method returns `true` if current request is initiated by Wiselinks and client want to render template (`X-Wiselinks != 'partial'`), `false` otherwise.

#### #wiselinks_partial? ###
Method returns `true` if current request is initiated by Wiselinks and client want to render partial (`X-Wiselinks == 'partial'`), `false` otherwise.

### Assets change detection

You can enable assets change detection with Wiselinks. To do this you have to enable assets digests by adding this to you environment file:

```ruby
config.assets.digest = true
```

Then you should append your layout by adding this to head section:

```erb
<%= wiselinks_meta_tag %>
```

Now Wiselinks will track changes of your assets and if anything will change, your page will be reloaded completely.

### Title handling

Wiselinks handles page titles by passing `X-Wiselinks-Title` header with response. To set this header you can use `wiselinks_title` helper (in Rails).

```html
<% wiselinks_title("Wiselinks is awesome") %>

<div>
	<!-- your content -->
	...
</div>
```

Of course you can use `wiselinks_title` helper in your own helpers too.

### Redirect handling

Wiselinks follows 30x HTTP redirects. Location is updated in browser with `X-Wiselinks-Url` header that is setting up automatically (in Rails) on every wiselinks request.

### Target missing handling

By default, if Wiselinks cannot find target that you specified during initialization, it will fail silently. But you can override this behaviour:

```coffeescript
#= require jquery
#= require wiselinks

$(document).ready ->
    window.wiselinks = new Wiselinks(
      $('something that does not exist'),
      target_missing: 'exception'
    )
```

`[Wiselinks] Target missing` exception will be thrown. This also works for `data-target` attributes.


### Google Analytics and Yandex Metrika

If you want to handle these analytics tools, then you should add handler to `page:done` event.

Let's say, that you have two objects, first is `_gaq` – instance of Google Analytics, second is `_metrika` – instance of Yandex Metrika. Then you have to add the following code somewhere in your `application.js.coffee`.

```coffeescript
$(document).off('page:done').on(
  'page:done'
  (event, $target, status, url, data) ->
    _gaq.push(['_trackPageview', url])
    _metrika.hit(url)
)
```

After this, you will have correct page view statistics in your analytics tools.


## Example

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

![JetRockets](http://www.jetrockets.ru/jetrockets.png)

Wiselinks is maintained by [JetRockets](http://www.jetrockets.ru).

Contributors:

* [Igor Alexandrov](http://igor-alexandrov.github.com/)
* [Alexey Solilin](https://github.com/solilin)
* [Julia Egorova](https://github.com/vankiru)
* [Alexandr Borisov](https://github.com/aishek)

## License

It is free software, and may be redistributed under the terms specified in the LICENSE file.

