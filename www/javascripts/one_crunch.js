(function() {
  new Vue({
    el: '#crunch1',
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
    }
  });

}).call(this);
