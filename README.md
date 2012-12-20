#Wiselinks
Wiselinks makes following links and submitting some forms in your web application faster. 

You may find Wiselinks similar to [Turbolinks](https://github.com/rails/turbolinks) or [Pjax](https://github.com/defunkt/jquery-pjax), but Wiselinks have several rather important differences from both projects. We tried to make Wiselinks as easy to use as Turbolinks are but also as configurable as Pjax.

##Compatibility
Wiselinks should work in all major browsers including browsers that do not support HTML History API out of the box.

## How does it work?


##Installation

Add this to your Gemfile:
	
	gem 'wiselinks'

Then do:
	
	bundle

Then modify your `application.js` or `application.js.coffee` file to use Wiselinks object:
	
```coffeescript	
#= require jquery
#= require wiselinks

$(document).ready ->
    window.wiselinks = new Wiselinks()
```	

And finally you should tell Wiselinks to process your links or forms:

```html	
<div>
<!--
link will fire History.pushState() event.
Data from the request will replace content of the container that was passed to Wiselinks (default to 'body')
-->
<a href='/path' data-push='true'>wiselinks are awesome</a>

<!--
link will fire History.replaceState() event.
Data from the request will replace content of the container that was passed to Wiselinks (default to 'body')
-->

<a href='/path' data-replace='true'>wiselinks are awesome</a>

</div>
```

You can add some options, if you want:

```coffeescript	
#= require jquery
#= require jquery.role
#= require wiselinks

$(document).ready ->
    # DOM element with role = 'content' will be replaced after data load.    	
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

    $(document).off('page:success').on(
        'page:success'
        (event, data, status) ->        
            console.log("Wiselinks status: '#{status}'")
            # stop loading animation
    )

    $(document).off('page:error').on(
        'page:error'
        (event, data, status) ->        
            console.log("Wiselinks status: '#{status}'")
            # stop loading animation and show error message
    )
```     	

## Javascript Events

While using Wiselinks you **can rely** on `DOMContentLoaded` or `jQuery.ready()` to trigger your JavaScript code, but Wiselinks gives you some additional useful event to deal with the lifecycle of the page:

### page:loading (url, target, render = 'template')

Event is triggered before the `XMLHttpRequest` is initialized and performed.
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

## ActionController::Base Methods

Wiselinks adds a couple of methods to your controller. These methods are mostly syntax sugar and don't have any complex logic, so you can use them or not.

### #wiselinks_request? ###
Method returns `true` if current request is initiated by Wiselinks, `false` otherwise. 

### #wiselinks\_template\_request? ###
Method returns `true` if current request is initiated by Wiselinks and client want to render template, `false` otherwise. 

### #wiselinks\_partial\_request? ###
Method returns `true` if current request is initiated by Wiselinks and client want to render partial, `false` otherwise. 


##Example

We crafted small example application that uses Wiselinks so you can see it in action.

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

## Copyright

Copyright (c) 2012 [Igor Alexandrov](http://igor-alexandrov.github.com/), [Alexey Solilin](https://github.com/solilin) and [Julia Egorova](https://github.com/vankiru). See LICENSE for details.
	