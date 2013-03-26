#= require _json2
#= require _history
#= require _history.html4
#= require _history.adapter.jquery.js

String.prototype.ends_with = (suffix) ->
  this.indexOf(suffix, this.length - suffix.length) != -1

class Wiselinks
  constructor: (@$target = $('body'), @options = {}) ->
    # Check that JQuery is available
    throw "Load jQuery to use Wiselinks" unless window.jQuery?

    self = this

    @options = jQuery.extend(self._defaults(), @options);
    @template_id = new Date().getTime()

    if self.enabled()
      @assets_digest = $("meta[name='assets-digest']").attr("content")

      if History.emulated.pushState && @options.html4 == true
        if window.location.href.indexOf('#!') == -1 && @options.html4_root_path != null && window.location.pathname != @options.html4_root_path
          window.location.href = "#{window.location.protocol}//#{window.location.host}#{@options.html4_root_path}#!#{window.location.pathname}"
        
        if window.location.hash.indexOf('#!') != -1                 
          self._call(self._make_state(window.location.hash.substring(2)))    

      History.Adapter.bind(
        window,
        "statechange"
        (event, data) ->
          state = History.getState()
          
          if self._template_id_changed(state)
            self._call(self._reset_state(state))
          else            
            self._call(state)
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
          if self._cross_origin_link(event.currentTarget) || self._non_standard_click(event)
            return true;        
          self._process_link($(this))

          event.preventDefault()
          return false
      )           
  
  enabled: ->
    !History.emulated.pushState || @options.html4 == true 

  load: (url, target, render = 'template') ->    
    @template_id = new Date().getTime() if render != 'partial'
    History.pushState({ template_id: @template_id, render: render, target: target, referer: window.location.href }, document.title, url )

  reload: () ->
    History.replaceState({ template_id: @template_id, render: 'template', referer: window.location.href }, document.title, History.getState().url )

  _defaults: ->
    html4: true
    html4_root_path: '/'

  _call: (state) ->
    self = this

    $target = if state.data.target? then $(state.data.target) else self.$target
    $document = $(document)
    
    if @redirected
      $document.trigger('page:redirected', [$target, state.data.render, state.url])
      @redirected = null
      return

    $document.trigger('page:loading', [$target, state.data.render, state.url])

    $.ajax(
      url: state.url
      headers:
        'X-Wiselinks': state.data.render
        'X-Wiselinks-Referer': state.data.referer
    
      dataType: "html"
    ).done(
      (data, status, xhr) ->
        url = xhr.getResponseHeader('X-Wiselinks-Url')

        if self._assets_changed(xhr.getResponseHeader('X-Wiselinks-Assets-Digest'))
          window.location.reload(true)        
        else
          self._set_title(xhr)

          if url? && url != window.location.href            
            if ( xhr && xhr.readyState < 4)            
              xhr.onreadystatechange = $.noop
              xhr.abort()
            self.redirected = true
            History.replaceState(History.getState().data, document.title, url )
                  
          $target.html(data)
          $document.trigger('page:done', [$target, status, state.ur, data])
    ).fail(
      (xhr, status, error) ->
        $document.trigger('page:fail', [$target, status, state.ur, error])
    ).always(
      (data_or_xhr, status, xhr_or_error)->
        $document.trigger('page:always', [$target, status, state.ur])
    )

  _process_form: ($form) ->
    self = this
    
    $disable = $form.find(':input[value=""]:not(:disabled)')
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
    # we split host because IE returns host with port and other browsers not
    (location.protocol != link.protocol) || (location.host.split(':')[0] != link.host.split(':')[0])    

  _non_standard_click: (event) ->
    event.metaKey || event.ctrlKey || event.shiftKey || event.altKey  

  _assets_changed: (digest) ->
    @assets_digest? && @assets_digest != digest

  _template_id_changed: (state) ->    
    !state.data.template_id? || state.data.template_id != @template_id

  _set_title: (xhr) ->
    value = xhr.getResponseHeader('X-Wiselinks-Title')
    document.title = decodeURI(value) if value?

  _make_state: (url, target, render = 'template', referer) ->
    { 
      url: url
      data:
        target: target
        render: render
        referer: referer
    }
  
  _reset_state: (state) ->
    state.data = {} unless state.data?    
    state.data.target = null
    state.data.render = 'template'
    state
    
window.Wiselinks = Wiselinks