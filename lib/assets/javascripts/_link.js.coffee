class Link
  constructor: (@page, @$link) -> 
  
  allows_process: (event) ->
    !(this._cross_origin_link(event.currentTarget) || this._non_standard_click(event))

  process: -> 
    type = if (@$link.attr("data-push") == 'partial') then 'partial' else 'template'
    @page.load(@$link.attr("href"), @$link.attr("data-target"), type)

  # We split host because IE returns host with port and other browsers not
  # 
  _cross_origin_link: (link) ->  
    (location.protocol != link.protocol) || (location.host.split(':')[0] != link.host.split(':')[0])    

  _non_standard_click: (event) ->
    event.metaKey || event.ctrlKey || event.shiftKey || event.altKey

window._Wiselinks = {} if window._Wiselinks == undefined
window._Wiselinks.Link = Link    