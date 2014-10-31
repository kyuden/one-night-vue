new Vue
  el: '#demo5'
  data:
    nameList: []
    displayName: ""
    newName: ""
  methods:
    addName: ->
      @displayName = @newName
      @newName = ""
