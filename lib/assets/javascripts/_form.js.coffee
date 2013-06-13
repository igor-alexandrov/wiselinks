class Form
  constructor: (@page, @$form) ->

  process: ->
    selector = 'select:not(:disabled),input:not(:disabled)'
    $disable = @$form.find(selector).filter(-> !$(this).val())

    $disable.attr('disabled', true)
    url = this._url()
    $disable.attr('disabled', false)

    @page.load(url, @$form.attr("data-target"), this._type())

  _params: ->
    hash = {}

    for item in @$form.serializeArray()
      if item.name != 'utf8'
        # if name ends with [], then we try to optimize it
        name = if item.name.indexOf('[]', item.name.length - '[]'.length) != -1
          item.name.substr(0, item.name.length - 2)
        else
          item.name

        if hash[name]?
          hash[name] = hash[name] + ",#{item.value}"
        else
          hash[name] = item.value

    hash

  _type: ->
    if (@$form.attr("data-push") == 'partial') then 'partial' else 'template'

  _url: ->
    serialized = []

    # To find out why encodeURIComponent should be used, follow the link:
    # http://stackoverflow.com/questions/75980/best-practice-escape-or-encodeuri-encodeuricomponent
    #
    for key, value of this._params()
      serialized.push("#{key}=#{encodeURIComponent(value)}")

    serialized = serialized.join('&')
    
    url = @$form.attr("action")
    url += "?#{serialized}" if serialized.length > 0
    url

window._Wiselinks = {} if window._Wiselinks == undefined
window._Wiselinks.Form = Form