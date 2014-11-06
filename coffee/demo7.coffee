new Vue
  el: '#demo7'
  data:
    todos: []
    newTodo: ""
  methods:
    addTodo: ->
      value = @newTodo
      @todos.push
       todo: value,
       done: false
      @newTodo = ""
  computed:
    activeLength: ->
      @todos.filter((todo) ->
          !todo.done
        ).length
    allDone:
      get: ->
        @activeLength == 0
      set: (value) ->
        @todos.forEach (todo) ->
          todo.done = value
