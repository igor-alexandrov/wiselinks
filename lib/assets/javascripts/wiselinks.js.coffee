#= require _history
#= require _history.html4
#= require _history.adapter.jquery.js

String.prototype.ends_with = (suffix) ->
  this.indexOf(suffix, this.length - suffix.length) != -1

class Wiselinks
  constructor: (@$target = $('body'), @options = {}) ->
    # Check that JQuery is available
    throw "Load JQuery to use Wiselinks" unless window.jQuery?

    self = this

    @options = jQuery.extend(self._defaults(), @options);

    if History.emulated.pushState && @options.html4 == true
      if window.location.href.indexOf('#!') == -1 && window.location.pathname != '/'                 
        window.location.href = "#{window.location.protocol}//#{window.location.host}/#!#{window.location.pathname}"
      
      if window.location.hash.indexOf('#!') != -1                 
        self._call(window.location.hash.substring(2))    

    History.Adapter.bind(
      window,
      "statechange"
      (event, data) ->
        return false if (!History.ready)
  
        state = History.getState()         
        self._call(state.url, state.data.target, state.data.render)        
    )
    
    $(document).on(
      "submit", "form[data-push], form[data-replace]"
      (event) ->        
        self._process_form($(this))
        
        event.preventDefault()
        return false
    )
  
    $(document).on(
      "click", "a[data-push], a[data-replace]"
      (event) ->      
        if self._cross_origin_link(event.target) || self._non_standard_click(event)
          return true;        
        self._process_link($(this))

        event.preventDefault()
        return false
    )     

    @assets_digest = $("meta[name='assets-digest']").attr("content")
  
  load: (url, target, render = 'template') ->
    History.ready = true
    History.pushState({ timestamp: (new Date().getTime()), render: render, target: target }, document.title, url )

  reload: () ->
    History.ready = true
    History.replaceState({ timestamp: (new Date().getTime()), render: 'template' }, document.title, History.getState().url )

  _defaults: ->
    html4: true

  _call: (url, target, render = 'template') ->
    self = this

    $target = if target? then $(target) else self.$target

    $document = $(document).trigger('page:loading', [url, $target.selector, render])

    $.ajax(
      url: url
      headers:
        'X-Render': render
      complete: (event, xhr, settings) ->
        $document.trigger('page:complete', [event, xhr, settings])

      success: (data, status, xhr) ->                
        if self._assets_changed(xhr.getResponseHeader('X-Assets-Digest'))
          window.location.reload(true)
        else
          self._set_title(xhr)
          
          $target.html(data)

          $document.trigger('page:success', [data, status])
      error: (xhr, status, error)->
        $document.trigger('page:error', [status, error])
      dataType: "html"
    )
  
  _process_form: ($form) ->
    self = this
    
    $disable = $form.find(':input[value=""]')
    $disable.attr('disabled', true);      
    
    params = {}

    for item in $form.serializeArray()
      if item.name != 'utf8'
        name = if item.name.ends_with('[]')
          item.name.substr(0, item.name.length - 2)
        else
          item.name

        if params[name]?
          params[name] = params[name] + ",#{item.value}"
        else
          params[name] = item.value  

    serialized = []
    for key of params
      serialized.push("#{key}=#{params[key]}")

    serialized = serialized.join('&').replace(/%|!/g, '')
    
    url = $form.attr("action")
    url += "?#{serialized}" if serialized.length > 0
        
    $disable.attr('disabled', false);    

    type = if ($form.attr("data-push") == 'partial') then 'partial' else 'template'  

    self.load(url, $form.attr("data-target"), type)
  
  _process_link: ($link) ->    
    self = this  
    
    type = if ($link.attr("data-push") == 'partial') then 'partial' else 'template'

    self.load($link.attr("href"), $link.attr("data-target"), type)

  _cross_origin_link: (link) ->
    (location.protocol != link.protocol) || (location.host != link.host)

  _non_standard_click: (event) ->
    event.metaKey || event.ctrlKey || event.shiftKey || event.altKey  

  _assets_changed: (digest) ->
    @assets_digest? && @assets_digest != digest

  _set_title: (xhr) ->
    value = xhr.getResponseHeader('X-Title')
    document.title = value if value?

window.Wiselinks = Wiselinks