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
        this.todos.push({
          todo: value,
          done: false
        });
        return this.newTodo = "";
      }
    }
  });

}).call(this);
