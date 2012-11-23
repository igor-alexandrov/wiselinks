#= require _history

class Wiselinks
  constructor: () ->
    # check that JQuery or Zepto.js are available
    throw "Load JQuery or Zepto.js to use Wiselinks" unless window.JQuery? || window.Zepto?

    self = this

    History.Adapter.bind(
      window,
      "statechange"
      (event, data) ->
        return if (!History.ready)
  
        state = History.getState()         
        self._call(state.url, state.data.target, state.data.slide)  

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
  
  load: (url, target, slide = 'template') ->
    History.ready = true
    History.pushState({ timestamp: (new Date().getTime()), slide: slide, target: target }, document.title, decodeURI(url) )    

  reload: () ->    
    History.ready = true
    History.replaceState({ timestamp: (new Date().getTime()), slide: 'template' }, document.title, decodeURI(History.getState().url) )    

  _call: (url, target, slide = 'template') ->    
    $(document).trigger('wiselinks:loading')

    $.ajax(
      url: url      
      headers:
        'X-Slide': slide  
      success: (data) ->                
        $(document).trigger('wiselinks:success', data)
        # window.app.managers.data.set(data, target)
        # window.app.managers.analytics.hit()

      error: ->        
        $(document).trigger('wiselinks:error')
        # window.app.managers.data.loaded()
      # statusCode:
      #   401: ->
      #     window.location = ROOT_PATH + "auth/login"
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
    for key in params
      serialized.push("#{params[key]}=key")

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