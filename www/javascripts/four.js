(function() {
  new Vue({
    el: '#demo4',
    data: {
      todos: [
        {
          done: true,
          content: 'Learn JS'
        }, {
          done: false,
          content: 'Learn vue.js'
        }, {
          done: true,
          content: 'Lean yourself'
        }
      ]
    }
  });

}).call(this);
