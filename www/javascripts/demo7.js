(function() {
  new Vue({
    el: "#demo7",
    data: {
      firstName: "Masahiro",
      lastName: "kyuden"
    },
    computed: {
      fullName: {
        get: function() {
          return this.firstName + '' + this.lastName;
        },
        set: function(newName) {
          var value;
          value = newName.split(' ');
          this.firstName = value[0];
          return this.lastName = value[value.length - 1];
        }
      }
    }
  });

}).call(this);
