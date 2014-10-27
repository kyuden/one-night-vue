(function() {
  var demo11;

  Vue.component('user-profile', {
    template: '{{name}} <br> {{email}}'
  });

  demo11 = new Vue({
    el: '#demo11',
    data: {
      title: 'demo11',
      sub_title: 'Inheriting Objects from Parent as $data',
      parentMsg: 'parent',
      user: {
        name: 'kyuden',
        email: 'msmsms.u@gmail.com'
      },
      users: [
        {
          name: "k",
          email: 'com'
        }, {
          name: 'a',
          email: 'jp'
        }
      ]
    },
    components: {
      child: {
        template: '<input v-model="childMsg">'
      }
    }
  });

}).call(this);
