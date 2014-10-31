new Vue
  el: '#demo5'
  data:
    nameList: []
    newName: ""
  methods:
    addName: ->
      @nameList.push
        name: @newName
      @newName = ""
