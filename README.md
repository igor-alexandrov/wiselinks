#Wiselinks
Wiselinks makes following links and submitting some forms in your web application faster. 

You may find Wiselinks similar to [Turbolinks](https://github.com/rails/turbolinks) or [Pjax](https://github.com/defunkt/jquery-pjax), but Wiselinks have several rather important differences from both projects. We tried to make Wiselinks as easy to use as Turbolinks are but also as configurable as Pjax.

##Compatibility
Wiselinks should work in all major browsers including browsers that do not support HTML History API out of the box.

##Installation

Add this to your Gemfile:
	
	gem 'wiselinks'

Then do:
	
	bundle

Then modify your `application.js` or `application.js.coffee` file to use Wiselinks object:
	
	#= require jquery
	#= require wiselinks
    
    $(document).ready ->
    	window.wiselinks = new Wiselinks()

##Events

While using Wiselinks you **can rely** on `DOMContentLoaded` or `jQuery.ready()` to trigger your JavaScript code, but Wiselinks gives you some additional useful event to deal with the lifecycle of the page:

#### `page:loading (url, target, render = 'template')`
Event is triggered before the `XMLHttpRequest` is initialized and performed.
* *url* - URL of the request that will be performed;

* *target* – element of the page where result of the request will be loaded into;

* *render = 'template'* – what should be rendered; can be 'template' or 'partial';

#### `page:success (data, status)`
Event is triggered if the request succeeds.
* *data* – the data returned from the server;

* *status* – a string describing the status;

#### `page:error (status, error)`

Event is triggered if the request fails.

* *status* – a string describing the type of error that occurred;
* *error* – optional exception object, if one occurred;

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
	