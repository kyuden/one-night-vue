new Vue
  el: '#demo6-2'
  data:
    todos: []
    newTodo: ""
  methods:
    addTodo: ->
      value = this.newTodo
      return if value.length == 0
      this.todos.push
        todo: value
        done: false
      this.newTodo = ""
