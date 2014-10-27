new Vue
  el: '#demo5'
  data:
    nameList: []
    newName: ""
  methods:
    addName: ->
      value = this.newName
      this.nameList.push
        name: value
      this.newName = ""
