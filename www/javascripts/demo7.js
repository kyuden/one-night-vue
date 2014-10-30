(function() {
  new Vue({
    el: '#demo7',
    data: {
      todos: [],
      newTodo: ""
    },
    methods: {
      addTodo: function() {
        var value;
        value = this.newTodo;
        this.todos.push({
          todo: value,
          done: false
        });
        return this.newTodo = "";
      }
    },
    computed: {
      activeLength: function() {
        return this.todos.filter(function(todo) {
          return !todo.done;
        }).length;
      },
      allDone: {
        get: function() {
          return this.activeLength === 0;
        },
        set: function(value) {
          return this.todos.forEach(function(todo) {
            return todo.done = value;
          });
        }
      }
    }
  });

}).call(this);
