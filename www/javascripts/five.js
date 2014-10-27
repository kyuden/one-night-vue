(function() {
  new Vue({
    el: '#demo5',
    data: {
      nameList: [],
      newName: ""
    },
    methods: {
      addName: function() {
        var value;
        value = this.newName;
        this.nameList.push({
          name: value
        });
        return this.newName = "";
      }
    }
  });

}).call(this);
