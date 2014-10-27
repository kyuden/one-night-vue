new Vue
  el: '#demo6'
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
