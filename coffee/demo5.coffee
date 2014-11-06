new Vue
  el: '#demo5'
  data:
    nameList: []
    newName: ""
  methods:
    addName: ->
      value = @newName
      @nameList.push
        name: value
      @newName = ""
