#= require history


class Wiselinks
  constructor: () ->
    self = this

    History.Adapter.bind(
      window,
      "statechange"
      (event, data) ->
        return if (!History.ready)
  
        state = History.getState() 
        # self.load(state.url, state.data.target, state.data.slide)
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
  
  trigger_event: (name) ->
    event = document.createEvent('Event')
    event.initEvent(name, true, true)
    document.dispatchEvent(event)

  load: (url, target, slide = 'template') ->
    this.trigger_event('wiselinks:before_load')

    History.ready = true
    History.pushState({ timestamp: (new Date().getTime()), slide: slide, target: target }, document.title, decodeURI(url) )    
    
    this.trigger_event('wiselinks:after_load')

  reload: () ->
    this.trigger_event('wiselinks:before_reload')
    
    History.ready = true
    History.replaceState({ timestamp: (new Date().getTime()), slide: 'template' }, document.title, decodeURI(History.getState().url) )    

    this.trigger_event('wiselinks:after_reload')

  _call: (url, target, slide = 'template') ->
    window.app.managers.data.loading()
    $.ajax(
      url: url      
      headers:
        'X-Slide': slide  
      success: (data) ->
        window.app.managers.data.set(data, target)
        window.app.managers.analytics.hit()

      error: ->
        window.app.managers.data.loaded()
      statusCode:
        401: ->
          window.location = ROOT_PATH + "auth/login"
      dataType: "html"
    )

  _change_state: (url, target, type = 'template') ->    
    $.fancybox.close()
    title = window.app.managers.data.getTitle()
    
    History.pushState({ timestamp: (new Date().getTime()), slide: type, target: target }, title, decodeURI(url) )    
  
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

    params = _.map(params
      (k,v) ->
        "#{v}=#{k}"
    ).join('&').replace(/%|!/g, '')

    # params = params.map(
    #   (item) ->
    #     "#{item.name}=#{item.value}" unless item.name == 'utf8'
    # ).compact().value().join('&').replace(/%|!/g, '')
    
    url = $form.attr("action")
    url += "?#{params}" if params.length > 0
        
    $disable.attr('disabled', false);    

    type = if ($form.attr("data-push") == 'partial') then 'partial' else 'template'  

    self.load(url, $form.attr("data-target"), type)
  
  _process_link: ($link) ->    
    self = this  
    
    type = if ($link.attr("data-push") == 'partial') then 'partial' else 'template'

    self.load($link.attr("href"), $link.attr("data-target"), type)    