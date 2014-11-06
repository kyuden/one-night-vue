new Vue
  el: '#demo6-2'
  data:
    todos: []
    newTodo: ""
  methods:
    addTodo: ->
      value = @newTodo
      return if value.length == 0
      @todos.push
        todo: value
        done: false
      @newTodo = ""
