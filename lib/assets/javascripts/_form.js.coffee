class Form
  constructor: (@page, @$form) ->

  process: ->
    self = this

    if self._include_blank_values()
      self.page.load(self._url(), self._target(), self._type())
    else
      self._without_blank_values(
        ->
          self.page.load(self._url(), self._target(), self._type())
      )

  _without_blank_values: (callback) ->
    selector = 'select:not(:disabled),input:not(:disabled)'
    $disable = @$form.find(selector).filter(-> !$(this).val())

    $disable.attr('disabled', true)
    callback()
    $disable.attr('disabled', false)

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

  _include_blank_values: ->
    @$form.data('include-blank-values') == true

  _type: ->
    if (@$form.data('push') == 'partial') then 'partial' else 'template'

  _target: ->
    @$form.data('target')

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

window._Wiselinks ?= {}
window._Wiselinks.Form = Form