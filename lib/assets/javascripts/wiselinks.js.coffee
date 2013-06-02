#= require_tree ./lib

#= require _page
#= require _link
#= require _form

class Wiselinks
  constructor: ($target = $('body'), @options = {}) ->
    this._try_jquery()

    @options = $.extend(this._defaults(), @options)
    if this.enabled()      
      @page = new _Wiselinks.Page($target, @options)

  enabled: ->
    !History.emulated.pushState || @options.html4 == true 

  load: (url, target, render = 'template') ->
    @page.load(url, target, render)

  reload: () ->
    @page.reload()
  
  _defaults: ->
    html4: true
    html4_root_path: '/'
    target_missing: null
    assets_digest: $("meta[name='assets-digest']").attr("content")      

  _try_jquery: ->
    throw "[Wiselinks] jQuery is not loaded" unless window.jQuery?  

window.Wiselinks = Wiselinks