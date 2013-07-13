class Link
  constructor: (@page, @$link) ->
    @cross_domain_check = new _Wiselinks.CrossDomainCheck()

  allows_process: (event) ->
    !(@cross_domain_check._cross_origin_link(event.currentTarget) ||
      @cross_domain_check._non_standard_click(event))

  process: ->
    type = if (@$link.data('push') == 'partial')
      'partial'
    else
      'template'

    @page.load(@$link.attr("href"), @$link.data('target'), type)

window._Wiselinks = {} if window._Wiselinks == undefined
window._Wiselinks.Link = Link
