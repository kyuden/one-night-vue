# #demo1
# demo1 = new Vue
#   el: '#demo1'
#   data:
#     title: 'demo1'
#     sub_title: 'TODO'
#     todos: [
#       {
#         done: true
#         content: 'Learn JavaScript'
#       }
#       {
#         done: false
#         content: 'Learn vue.js'
#       }
#       {
#         done: true
#         content: 'Lean kyuden'
#       }
#     ]
#     user: "kebin"

# #demo2
# Vue.directive 'demo2',
#   bind: ->
#     this.el.style.color = "#fff"
#     this.el.style.backgroundColor = this.arg

#   update: (value) ->
#     this.el.innerHTML =
#       'argument - ' + this.arg + '<br>' +
#       'key - ' + this.key + '<br>' +
#       'value - ' + value

# demo2 = new Vue
#   el: '#demo2'
#   data:
#     title: "demo2"
#     sub_title: "Custom Directive"
#     msg: 'hello!'

# #demo3
# Vue.directive 'demo3-1',
#   isLiteral: true
#   bind: ->
#     this.el.innerHTML =
#      'expression: ' + this.expression + ' arg: ' + this.arg + ' key: ' + this.key

#   #isLiteralがtrueなので呼ばれない
#   update: (value) ->
#     this.el.innerHTML =
#       'foooooooooooooooooooooooo'

# Vue.directive 'demo3-2',
#   isEmpty: true
#   bind: ->
#     this.el.innerHTML =
#      'expression: ' + this.expression + ' arg: ' + this.arg + ' key: ' + this.key

#   #isLiteralがtrueなので呼ばれない
#   update: (value) ->
#     this.el.innerHTML =
#       'foooooooooooooooooooooooo'

# demo3 = new Vue
#   el: '#demo3'
#   data:
#     title: "demo3"
#     sub_title: "Literal & Empty"

# #demo4
# Vue.filter 'reversename',
#   (value) ->
#     value.split('').reverse().join('')


# demo4 = new Vue
#   el: '#demo4'
#   data:
#     title: "demo4"
#     sub_title: "Custom Filter"
#     name: "kyuden"

# #demo5
# demo5 = new Vue
#   el: '#demo5'
#   data:
#     title: 'demo5'
#     sub_title: 'Display a List'
#     parentMsg: "parent Hello"
#     items: [
#       {
#         childMsg: 'child1 Hello'
#       }
#       {
#         childMsg: 'child2 Hello'
#       }
#     ]
#     premitiveValues:
#       FirstName: "masahiro"
#       LastName:  "kyuden"
#       Age: 25
#     objectValues:
#       one:
#         msg: 'Hello'
#         dummy: 'dummy'
#       two:
#         msg: "Bye"

# #demo6
# demo6 = new Vue
#   el: "#demo6"
#   data:
#     title: 'demo6'
#     sub_title: 'Listening for Events'
#     n: 0
#   methods:
#     onClick: (e) ->
#       console.log("#{e.targetVM}")
#       e.srcElement.innerHTML =
#         "#{e.target.tagName} tag is clicked."

# #demo7
# demo7 = new Vue
#   el: "#demo7"
#   data:
#     title: 'demo7'
#     sub_title: 'Invoke Handler with Expression'
#     items: [
#       {
#         text: 'one', done: true
#       }
#       {
#         text: 'two', done: false
#       }
#     ]
#   methods:
#     toggle: (item) ->
#       item.done = !item.done

# #demo8
# demo8 = new Vue
#   el: "#demo8"
#   data:
#     title: 'demo8'
#     sub_title: 'The Special Key Filter'

# #demo9
# demo9 = new Vue
#   el: "#demo9"
#   data:
#     title: 'demo9'
#     sub_title: 'Handring Forms'
#     msg: 'hello'
#     checked: true
#     picked: 'two'
#     selected: 'two'

# #demo10
# demo10 = new Vue
#   el: '#demo10'
#   data:
#     title: 'demo10'
#     sub_title: 'Computed properties'
#     firstName: "masahiro"
#     lastName:  "kyuden"
#   computed:
#     fullName:
#       $get: ->
#         this.firstName + " " + this.lastName
#       $set: (value) ->
#         names = value.split(' ')
#         this.firstName = names[0]
#         this.lastName  = names[names.length - 1]

#demo11

Vue.component 'user-profile',
  template: '{{name}} <br> {{email}}'

demo11 = new Vue
  el: '#demo11'
  data:
    title: 'demo11'
    sub_title: 'Inheriting Objects from Parent as $data'
    parentMsg: 'parent'
    user:
      name: 'kyuden'
      email: 'msmsms.u@gmail.com'
    users:[
      {
        name: "k"
        email: 'com'
      }
      {
        name: 'a'
        email: 'jp'
      }
    ]

  components:
    child:
      template: '<input v-model="childMsg">'






