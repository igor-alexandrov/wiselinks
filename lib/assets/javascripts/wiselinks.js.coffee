#= require _json2
#= require _history
#= require _history.html4
#= require _history.adapter.jquery

#= require core_ext
#= require page
#= require link
#= require form

class Wiselinks
  constructor: ($target = $('body'), options = {}) ->
    self = this
    this._try_jquery()

    if this.enabled()
      options = $.extend(this._defaults(), options)
      options.assets_digest = $("meta[name='assets-digest']").attr("content")      

      if History.emulated.pushState && @options.html4 == true
        if window.location.href.indexOf('#!') == -1 && options.html4_root_path != null && window.location.pathname != options.html4_root_path
          window.location.href = "#{window.location.protocol}//#{window.location.host}#{@options.html4_root_path}#!#{window.location.pathname}"
        
        # if window.location.hash.indexOf('#!') != -1                 
        #   this._call(this._make_state(window.location.hash.substring(2)))    

      $(document).on(
        'click', 'a[data-push], a[data-replace]'
        (event) ->
          if (link = new _Wiselinks.Link(self.page, $(this))).allows_process(event)
            event.preventDefault()
            link.process()

            return false
      )

      $(document).on(
        'submit', 'form[data-push], form[data-replace]'
        (event) ->
          if (form = new _Wiselinks.Form(self.page, $(this)))
            event.preventDefault()
            form.process()

            return false
      )

      @page = new _Wiselinks.Page($target, options)

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

  _try_jquery: ->
    throw "[Wiselinks] jQuery is not loaded" unless window.jQuery?  

window.Wiselinks = Wiselinks