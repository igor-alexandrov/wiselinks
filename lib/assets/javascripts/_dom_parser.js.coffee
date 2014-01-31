class DOMParser
  parse: (html) ->
    @_get_parser()(html)

  _get_parser: ->
    @_document_parser ?= @_parser_factory()

  # fully taken from Turbolinks :)
  _parser_factory: ->
    createDocumentUsingParser = (html) ->
      (new DOMParser).parseFromString html, 'text/html'

    createDocumentUsingDOM = (html) ->
      doc = document.implementation.createHTMLDocument ''
      doc.documentElement.innerHTML = html
      doc

    createDocumentUsingWrite = (html) ->
      doc = document.implementation.createHTMLDocument ''
      doc.open 'replace'
      doc.write html
      doc.close()
      doc

    # Use createDocumentUsingParser if DOMParser is defined and natively
    # supports 'text/html' parsing (Firefox 12+, IE 10)
    #
    # Use createDocumentUsingDOM if createDocumentUsingParser throws an exception
    # due to unsupported type 'text/html' (Firefox < 12, Opera)
    #
    # Use createDocumentUsingWrite if:
    #  - DOMParser isn't defined
    #  - createDocumentUsingParser returns null due to unsupported type 'text/html' (Chrome, Safari)
    #  - createDocumentUsingDOM doesn't create a valid HTML document (safeguarding against potential edge cases)
    try
      if window.DOMParser
        testDoc = createDocumentUsingParser '<html><body><p>test'
        createDocumentUsingParser
    catch e
      testDoc = createDocumentUsingDOM '<html><body><p>test'
      createDocumentUsingDOM
    finally
      unless testDoc?.body?.childNodes.length is 1
        return createDocumentUsingWrite


window._Wiselinks ?= {}
window._Wiselinks.DOMParser = DOMParser
