new Vue
  el: '#demo7'
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
  computed:
    activeLength: ->
      this.todos.filter((todo) ->
          !todo.done
        ).length
    allDone:
      get: ->
        this.activeLength == 0
      set: (value) ->
        this.todos.forEach (todo) ->
          todo.done = value
