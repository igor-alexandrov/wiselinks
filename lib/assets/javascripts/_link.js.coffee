class Link
  constructor: (@page, @$link) ->

  allows_process: (event) ->
    !(this._cross_origin_link(event.currentTarget) ||
      this._non_standard_click(event))

  process: ->
    type = if (@$link.data('push') == 'partial')
      'partial'
    else
      'template'

    @page.load(@$link.attr("href"), @$link.data('target'), type)

  # We split host because IE returns host with port and other browsers not
  #
  _cross_origin_link: (link) ->
    (location.protocol != link.protocol) ||
    (!_compare_link_port_with_location_port(link)) ||
    (location.host.split(':')[0] != link.host.split(':')[0])

  #
  # private method for port comparison
  # IE10 returns for link.port "80" but the location.port is ""
  # stupid but "modern" browsers returning the same values
  #
  _compare_link_port_with_location_port = (link) ->
    (location.port == link.port) ||
    (location.port == "" && link.port == "80")


  _non_standard_click: (event) ->
    event.metaKey || event.ctrlKey || event.shiftKey || event.altKey

window._Wiselinks = {} if window._Wiselinks == undefined
window._Wiselinks.Link = Link