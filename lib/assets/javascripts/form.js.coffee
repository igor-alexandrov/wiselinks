class Form
  constructor: (@page, @$form) -> 

  process: ->
    $disable = @$form.find('select:not(:disabled),input:not(:disabled)').filter(-> !$(this).val())
    $disable.attr('disabled', true);      
    
    params = {}

    for item in @$form.serializeArray()
      if item.name != 'utf8'
        name = if item.name.ends_with('[]')
          item.name.substr(0, item.name.length - 2)
        else
          item.name

        if params[name]?
          params[name] = params[name] + ",#{item.value}"
        else
          params[name] = item.value  

    serialized = []
    for key of params
      serialized.push("#{key}=#{encodeURIComponent(params[key])}")

    serialized = serialized.join('&')
    
    url = @$form.attr("action")
    url += "?#{serialized}" if serialized.length > 0
        
    $disable.attr('disabled', false);    

    type = if (@$form.attr("data-push") == 'partial') then 'partial' else 'template' 
    @page.load(url, @$form.attr("data-target"), type)

window._Wiselinks = {} if window._Wiselinks == undefined
window._Wiselinks.Form = Form        