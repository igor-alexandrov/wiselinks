class Select
  constructor: (@page, @$select) ->

  allows_process: (event) ->
    if @page.options.allow_cross_origin
      return !this._non_standard_click(event)
    else
      return !(this._cross_origin_link(event.currentTarget) || this._non_standard_click(event))

  process: ->
    type = if (@$select.data('push') == 'partial')
      'partial'
    else
      'template'

    url = this._add_param_to_url(@$select.data('url'), @$select.data('param') || 'id', @$select.val())
    @page.load(url, @$select.data('target'), type, @$select.data('scope'), @$select.data('wise'))

  _add_param_to_url: (url, param, value) ->
    link = this._create_link(url)
    result = new RegExp(param + '=([^&]*)', 'i').exec(link.search);
    result = result && result[1] || '';
    if result == ''
      opt = {}; opt[param] = value
      if link.search == ''
        url += '?' + $.param(opt);
      else
        url += '&' + $.param(opt);
    return url;

  _create_link: (url) ->
    link = document.createElement('a')
    link.href = url
    return link

  _cross_origin_link: (select) ->
    link = this._create_link($(select).data('url'))
    this._different_protocol(link) ||
    this._different_host(link) ||
    this._different_port(link)

  _different_protocol: (link) ->
    return false if link.protocol == ':' || link.protocol == ''
    location.protocol != link.protocol

  # IE returns host with port and all other browsers return host without port
  #
  _different_host: (link) ->
    return false if link.host == ''
    (location.host.split(':')[0] != link.host.split(':')[0])

  # IE returns for link.port "80" but the location.port is ""
  # Stupid but "modern" browsers return correct values
  #
  _different_port: (link) ->
    port_equals = (location.port == link.port) ||
      (location.port == '' && (link.port == '80' || link.port == '443'))

    !port_equals

  _non_standard_click: (event) ->
    event.metaKey || event.ctrlKey || event.shiftKey || event.altKey

window._Wiselinks = {} if window._Wiselinks == undefined
window._Wiselinks.Select = Select
