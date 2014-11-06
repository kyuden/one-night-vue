(function() {
  new Vue({
    el: '#demo5',
    data: {
      nameList: [],
      displayName: "",
      newName: ""
    },
    methods: {
      addName: function() {
        this.displayName = this.newName;
        return this.newName = "";
      }
    }
  });

}).call(this);
