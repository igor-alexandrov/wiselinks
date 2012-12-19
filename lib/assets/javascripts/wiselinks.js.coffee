#= require _history

String.prototype.ends_with = (suffix) ->
  this.indexOf(suffix, this.length - suffix.length) != -1

class Wiselinks
  constructor: (@$target = $('body'), options = {}) ->
    # check that JQuery or Zepto.js are available
    throw "Load JQuery to use Wiselinks" unless window.jQuery?

    self = this

    History.Adapter.bind(
      window,
      "statechange"
      (event, data) ->
        return if (!History.ready)
  
        state = History.getState()         
        self._call(state.url, state.data.target, state.data.render)  

        return false
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
        if (event.ctrlKey || event.metaKey)
          return true;
        
        self._process_link($(this))

        event.preventDefault()
        return false
    )
  
  load: (url, target, render = 'template') ->
    History.ready = true
    History.pushState({ timestamp: (new Date().getTime()), render: render, target: target }, document.title, decodeURI(url) )

  reload: () ->
    History.ready = true
    History.replaceState({ timestamp: (new Date().getTime()), render: 'template' }, document.title, decodeURI(History.getState().url) )

  _call: (url, target, render = 'template') ->
    self = this
    $(document).trigger('page:loading', url, target, render)

    $.ajax(
      url: url
      headers:
        'X-Render': render
      success: (data, status, xhr) ->
        document.title = xhr.getResponseHeader('X-Title')        

        $target = if target? then $(target) else self.$target
        $target.html(data)

        $(document).trigger('page:success', data, status)
      error: (xhr, status, error)->        
        $(document).trigger('page:error', status, error)
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

window.Wiselinks = Wiselinks