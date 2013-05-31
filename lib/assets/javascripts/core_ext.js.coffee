String.prototype.ends_with = (suffix) ->
  this.indexOf(suffix, this.length - suffix.length) != -1