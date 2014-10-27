(function() {
  var app, filters;

  filters = {
    all: function() {
      return true;
    },
    active: function(todo) {
      return !todo.completed;
    },
    completed: function(todo) {
      return todo.completed;
    }
  };

  app = new Vue({
    el: "#todoapp",
    data: {
      todos: [],
      newTodo: "",
      editedTodo: null,
      filter: 'all'
    },
    computed: {
      remaining: function() {
        return this.todos.filter(filters.active).length;
      },
      allDone: {
        get: function() {
          return this.remaining === 0;
        },
        set: function(value) {
          return this.todos.forEach(function(todo) {
            return todo.completed = value;
          });
        }
      }
    },
    methods: {
      addTodo: function() {
        var value;
        value = this.newTodo && this.newTodo.trim();
        if (!value) {
          return;
        }
        this.todos.push({
          title: value,
          completed: false
        });
        return this.newTodo = "";
      },
      editTodo: function(todo) {
        this.beforeEditCache = todo.title;
        return this.editedTodo = todo;
      },
      doneEdit: function(todo) {
        this.beforeEditCache = null;
        this.editedTodo = null;
        return todo.title = todo.title.trim();
      },
      cancelEdit: function(todo) {
        this.editedTodo = null;
        return todo.title = this.beforeEditCache;
      },
      deleteTodo: function(todo) {
        return this.todos.$remove(todo.$data);
      }
    }
  });

  app.filters = filters;

}).call(this);
