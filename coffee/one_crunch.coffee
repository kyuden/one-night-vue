new Vue
  el: '#crunch1'
  data:
    todos: []
    newTodo: ""
  methods:
    addTodo: ->
      value = this.newTodo
      this.todos.push
       todo: value,
       done: false
      this.newTodo = ""
