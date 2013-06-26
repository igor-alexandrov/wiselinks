class Form
  constructor: (@page, @$form) ->

  process: ->
    @page.load(@_url(), @$form.data("target"), @_type())

  _params: ->
    hash = {}
    excludeBlanks = not @$form.data("include-blank")

    for item in @$form.serializeArray()
      unless item.name is 'utf8' or (excludeBlanks and not item.value)
        # if name ends with [], then we try to optimize it
        name = if item.name.indexOf('[]', item.name.length - '[]'.length) isnt -1
          item.name.substr(0, item.name.length - 2)
        else
          item.name

        if hash[name]?
          hash[name] = hash[name] + ",#{item.value}"
        else
          hash[name] = item.value

    hash

  _type: ->
    if (@$form.attr("data-push") is 'partial') then 'partial' else 'template'

  _url: ->
    serialized = []

    # To find out why encodeURIComponent should be used, follow the link:
    # http://stackoverflow.com/questions/75980/best-practice-escape-or-encodeuri-encodeuricomponent
    #
    for key, value of @_params()
      serialized.push("#{key}=#{encodeURIComponent(value)}")

    serialized = serialized.join('&')

    url = @$form.attr("action")
    url += "?#{serialized}" if serialized.length > 0
    url

window._Wiselinks ?= {}
window._Wiselinks.Form = Form