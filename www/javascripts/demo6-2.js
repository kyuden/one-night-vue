(function() {
  new Vue({
    el: '#demo6-2',
    data: {
      todos: [],
      newTodo: ""
    },
    methods: {
      addTodo: function() {
        var value;
        value = this.newTodo;
        if (value.length === 0) {
          return;
        }
        this.todos.push({
          todo: value,
          done: false
        });
        return this.newTodo = "";
      }
    }
  });

}).call(this);
