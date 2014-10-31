(function() {
  new Vue({
    el: '#demo5',
    data: {
      nameList: [],
      newName: ""
    },
    methods: {
      addName: function() {
        this.nameList.push({
          name: this.newName
        });
        return this.newName = "";
      }
    }
  });

}).call(this);
