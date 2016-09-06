module.exports =
  strContains: (str, searchValue) ->
    str && str.toLowerCase().indexOf(searchValue) > -1
