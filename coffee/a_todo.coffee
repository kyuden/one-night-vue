filters =
  all: ->
    true
  active: (todo) ->
    !todo.completed
  completed: (todo) ->
    todo.completed

app = new Vue
  el: "#todoapp"
  data:
    todos: []
    newTodo: ""
    editedTodo: null
    filter: 'all'
  computed:
    remaining: ->
      this.todos.filter(filters.active).length
    allDone:
      get: ->
        this.remaining == 0
      set: (value) ->
        this.todos.forEach (todo) ->
          todo.completed = value

  methods:
    addTodo: ->
      value = this.newTodo && this.newTodo.trim()
      return if (!value)
      this.todos.push
        title: value
        completed: false
      this.newTodo = ""

    editTodo: (todo) ->
      this.beforeEditCache = todo.title
      this.editedTodo = todo

    doneEdit: (todo) ->
      this.beforeEditCache = null
      this.editedTodo = null
      todo.title = todo.title.trim()

    cancelEdit: (todo) ->
      this.editedTodo = null
      todo.title = this.beforeEditCache

    deleteTodo: (todo) ->
      this.todos.$remove(todo.$data)

app.filters = filters





