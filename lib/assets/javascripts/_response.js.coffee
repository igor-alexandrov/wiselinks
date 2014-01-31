#= require _dom_parser

# if server responds with 304, sometimes you may get
# full page source instead of just wiselinks part, so
# you need to use different content extract strategies
class Response
  @_document_parser: null

  @_get_document_parser: ->
    Response._document_parser ?= new window._Wiselinks.DOMParser


  constructor: (@html, @xhr, @$target) ->

  content: ->
    @_content ?= @_extract_content()

  title: ->
    @_title ?= @_extract_title()

  _extract_title: ->
    if @_is_full_document_response()
      $('title', @_get_doc()).text()
    else
      @xhr.getResponseHeader('X-Wiselinks-Title')

  _extract_content: ->
    if @_is_full_document_response()
      @_get_doc_target_node().html()
    else
      @html

  _is_full_document_response: ->
    @_get_doc_target_node().length is 1

  _get_doc_target_node: ->
    @$doc_target_node ?= $(@$target.selector, @_get_doc())

  _get_doc: ->
    @_doc ?= Response._get_document_parser().parse(@html)



window._Wiselinks ?= {}
window._Wiselinks.Response = Response
