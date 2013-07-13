class CrossDomainCheck
  constructor: () ->

  _cross_origin_link: (link) ->
    this._different_protocol(link) ||
    this._different_host(link) ||
    this._different_port(link)

  _different_protocol: (link) ->
    location.protocol != link.protocol

  # IE returns host with port and all other browsers return host without port
  #
  _different_host: (link) ->
    (location.host.split(':')[0] != link.host.split(':')[0])

  # IE returns for link.port "80" but the location.port is ""
  # Stupid but "modern" browsers return correct values
  #
  _different_port: (link) ->
    port_equals = (location.port == link.port) ||
      (location.port == "" && link.port == "80")

    !port_equals

  _non_standard_click: (event) ->
    event.metaKey || event.ctrlKey || event.shiftKey || event.altKey

window._Wiselinks = {} if window._Wiselinks == undefined
window._Wiselinks.CrossDomainCheck = CrossDomainCheck
