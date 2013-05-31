#= require request_manager

class Page
  constructor: (@$target, @options) ->
    @template_id = new Date().getTime()
    @request_manager = new _Wiselinks.RequestManager(@options)

    this._try_target(@$target)

    History.Adapter.bind(
      window,
      "statechange"
      (event, data) =>
        state = History.getState()
        
        if this._template_id_changed(state)
          this._call(self._reset_state(state))
        else            
          this._call(state)
    )

  load: (url, target, render = 'template') ->
    @template_id = new Date().getTime() if render != 'partial'

    if target?
      this._try_target($(target))

    History.pushState({ timestamp: (new Date().getTime()), template_id: @template_id, render: render, target: target, referer: window.location.href }, document.title, url )

  reload: () ->    
    History.replaceState({ timestamp: (new Date().getTime()), template_id: @template_id, render: 'template', referer: window.location.href }, document.title, History.getState().url )
  
  _call: (state) ->
    $target = if state.data.target? then $(state.data.target) else @$target
    this.request_manager.call($target, state)

  _template_id_changed: (state) ->    
    !state.data.template_id? || state.data.template_id != @template_id

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
  
  _try_target: ($target) ->
    throw "[Wiselinks] Missing target #{$target.selector}" if $target.length == 0  && @options.target_missing == 'exception'

window._Wiselinks = {} if window._Wiselinks == undefined
window._Wiselinks.Page = Page