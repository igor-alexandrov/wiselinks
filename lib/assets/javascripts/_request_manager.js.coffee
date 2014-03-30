#= require _response

class RequestManager
  constructor: (@options = {}) ->

  call: ($target, state) ->
    self = this

    # If been redirected, just trigger event and exit
    #
    if @redirected?
      @redirected = null
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
        self._html_loaded($target, data, status, xhr)
    ).fail(
      (xhr, status, error) ->
        self._fail($target, status, state, error, xhr.status, xhr.responseText)
    ).always(
      (data_or_xhr, status, xhr_or_error)->
        self._always($target, status, state)
    )

  _normalize: (url) ->
    return unless url?

    url = url.replace /\/+$/, ''
    url

  _assets_changed: (assets_digest) ->
    @options.assets_digest? && @options.assets_digest != assets_digest

  _redirect_to: (url, $target, state, xhr) ->
    if ( xhr && xhr.readyState < 4)
      xhr.onreadystatechange = $.noop
      xhr.abort()

    @redirected = true
    $(document).trigger('page:redirected', [$target, state.data.render, url])
    History.replaceState(state.data, document.title, url)

  _loading: ($target, state) ->
    $(document).trigger('page:loading'
      [$target, state.data.render, decodeURI(state.url)]
    )

  _done: ($target, status, state, data) ->
    $(document).trigger('page:done'
      [$target, status, decodeURI(state.url), data]
    )

  _html_loaded: ($target, data, status, xhr) ->
    response = new window._Wiselinks.Response(data, xhr, $target)

    url = @_normalize(response.url())
    assets_digest = response.assets_digest()

    if @_assets_changed(assets_digest)
      window.location.reload(true)
    else
      state = History.getState()
      if url? && (url != @_normalize(state.url))
        @_redirect_to(url, $target, state, xhr)

      $target.html(response.content()).promise().done(
        =>
          @_title(response.title())
          @_description(response.description())
          @_canonical(response.canonical())
          @_robots(response.robots())
          @_link_rel_prev(response.link_rel_prev())
          @_link_rel_next(response.link_rel_next())
          @_done($target, status, state, response.content())
      )

  _fail: ($target, status, state, error, code, data) ->
    $(document).trigger('page:fail'
      [$target, status, decodeURI(state.url), error, code, data]
    )

  _always: ($target, status, state) ->
    $(document).trigger('page:always', [$target, status, decodeURI(state.url)])

  _title: (value) ->
    if value?
      $(document).trigger('page:title', decodeURI(value))
      document.title = decodeURI(value)

  _description: (value) ->
    if value?
      $(document).trigger('page:description', decodeURI(value))
      $('meta[name="description"]').attr('content', decodeURI(value))

  _canonical: (value) ->
    if value?
      $(document).trigger('page:canonical', decodeURI(value))
      $('link[rel="canonical"]').attr('href', decodeURI(value))

  _robots: (value) ->
    if value?
      $(document).trigger('page:robots', decodeURI(value))
      $('meta[name="robots"]').attr('content', decodeURI(value))

  _link_rel_prev: (value) ->
    if value?
      $(document).trigger('page:link_rel_prev', decodeURI(value))
      $('link[rel="prev"]').attr('href', decodeURI(value))

  _link_rel_next: (value) ->
    if value?
      $(document).trigger('page:link_rel_next', decodeURI(value))
      $('link[rel="next"]').attr('href', decodeURI(value))


window._Wiselinks = {} if window._Wiselinks == undefined
window._Wiselinks.RequestManager = RequestManager
