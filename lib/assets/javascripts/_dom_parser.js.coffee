class DOMParser
  parse: (html) ->
    @_get_parser()(html)

  _get_parser: ->
    @_document_parser ?= @_parser_factory()

  # fully taken from Turbolinks (https://github.com/rails/turbolinks)
  # and changed function names style
  # by @igor-alexandrov request :)
  _parser_factory: ->
    create_document_using_parser = (html) ->
      (new DOMParser).parseFromString html, 'text/html'

    create_document_using_DOM = (html) ->
      doc = document.implementation.createHTMLDocument ''
      doc.documentElement.innerHTML = html
      doc

    create_document_using_write = (html) ->
      doc = document.implementation.createHTMLDocument ''
      doc.open 'replace'
      doc.write html
      doc.close()
      doc

    # fallback to ie8 support
    create_document_using_iframe = (html) ->
      iframe = $('<iframe src="about:blank" style="display: none; position: absolute; z-index: -1;"></iframe>')
      iframe_parent = $('body')

      iframe_parent.append iframe
      doc = iframe[0].contentDocument
      doc.innerHTML = html
      iframe.remove()

      doc

    # Use create_document_using_parser if DOMParser is defined and natively
    # supports 'text/html' parsing (Firefox 12+, IE 10)
    #
    # Use create_document_using_DOM if create_document_using_parser throws an exception
    # due to unsupported type 'text/html' (Firefox < 12, Opera)
    #
    # Use create_document_using_write if:
    #  - DOMParser isn't defined
    #  - create_document_using_parser returns null due to unsupported type 'text/html' (Chrome, Safari)
    #  - create_document_using_DOM doesn't create a valid HTML document (safeguarding against potential edge cases)
    try
      if window.DOMParser
        testDoc = create_document_using_parser '<html><body><p>test'
        create_document_using_parser
    catch e
      testDoc = create_document_using_DOM '<html><body><p>test'
      create_document_using_DOM
    finally
      unless testDoc?.body?.childNodes.length is 1
        if @_should_fallback_to_iframe()
          return create_document_using_iframe
        else
          return create_document_using_write

  _should_fallback_to_iframe: ->
    document.implementation? and !document.implementation.createHTMLDocument


window._Wiselinks ?= {}
window._Wiselinks.DOMParser = DOMParser
