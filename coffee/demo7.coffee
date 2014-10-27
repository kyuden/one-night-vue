new Vue
  el: "#demo7"
  data:
    firstName: "Masahiro"
    lastName: "kyuden"
  computed:
    fullName:
      get: ->
        this.firstName + '' + this.lastName
      set: (newName) ->
        value = newName.split(' ')
        this.firstName = value[0]
        this.lastName = value[value.length - 1]
