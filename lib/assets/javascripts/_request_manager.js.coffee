class RequestManager
  constructor: (@options = {}) ->

  call: ($target, state) ->
    self = this

    # If been redirected, just trigger event and exit
    # 
    if @redirected
      self._handle_redirect($target, state)
      return

    # Trigger loading event
    # 
    self._loading($target, state)

    # Perform XHtmlHttpRequest
    # 
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
          if url? && url != window.location.href
            self._redirect_to(url, xhr)
                  
          $target.html(data)

          self._title(xhr.getResponseHeader('X-Wiselinks-Title'))
          self._done($target, status, state.url, data)
    ).fail(
      (xhr, status, error) ->
        self._fail($target, status, state.url, error)
    ).always(
      (data_or_xhr, status, xhr_or_error)->
        self._always($target, status, state.url)
    ) 

  _assets_changed: (digest) ->
    @options.assets_digest? && @options.assets_digest != digest

  _handle_redirect: ($target, state) ->
    $(document).trigger('page:redirected', [$target, state.data.render, state.url])
    @redirected = null

  _redirect_to: (url, xhr) ->
    if ( xhr && xhr.readyState < 4)
      xhr.onreadystatechange = $.noop
      xhr.abort()

    @redirected = true
    
    this._title('Redirecting…')
    History.replaceState(History.getState().data, document.title, url )


  _loading: ($target, state) ->
    $(document).trigger('page:loading', [$target, state.data.render, state.url])

  _done: ($target, status, state, data) ->
    $(document).trigger('page:done', [$target, status, state.url, data])

  _fail: ($target, status, state, error) ->
    $(document).trigger('page:fail', [$target, status, state.url, error])

  _always: ($target, status, state) ->
    $(document).trigger('page:always', [$target, status, state.url])

  _title: (value) ->
    if value?  
      $(document).trigger('page:title', decodeURI(value))
      document.title = decodeURI(value) if value?
  

window._Wiselinks = {} if window._Wiselinks == undefined
window._Wiselinks.RequestManager = RequestManager
