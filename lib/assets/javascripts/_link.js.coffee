class Link
  constructor: (@page, @$link) ->

  allows_process: (event) ->
    !(@page.cross_domain_check._cross_origin_link(event.currentTarget) ||
      @page.cross_domain_check._non_standard_click(event))

  process: ->
    type = if (@$link.data('push') == 'partial')
      'partial'
    else
      'template'

    @page.load(@$link.attr("href"), @$link.data('target'), type)

window._Wiselinks = {} if window._Wiselinks == undefined
window._Wiselinks.Link = Link
