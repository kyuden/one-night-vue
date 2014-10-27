# Original

http://vuejs.org/guide/

-----------------------

# Installation

IE8以下はサポートしない

# Getting Started

* ViewModelにフォーカスしたフレームワーク
* DOM操作はDirectivesやFiltersをつかう
* フルスタックなフレームワークではなくて、シンプルで柔軟にデザインされていて、他のライブラリと一緒に使うこともできる
* firebaseとの組み合わせもよい
* APIはAngularJS, KnockoutJS, Ractive.js、 Rivets.jsらに影響を受けてる
  * でもこれらよりもシンプル

## ViewModel

* Vueのコンストラクタから作ることが出来てViewとModelのデータをsyncする

## View

* vm.$elで参照出来る。Viewは自動的に更新されるので自分でDirectives作ったりして操作することはあまりない
* データの更新は非同期で行われるのでパフォーマンスにも優れている

## Model

* ただのJavaScriptのオブジェクト
* データの更新はES5のsetter getterによってフックされているので使う側は意識しなくてもいい

## Directives

* HTML属性として利用することでDOM操作を隠蔽してくれる

## Mustache Bindings

* テキストや属性の指定でMustacheのBindingを使うことが出来る
* img srcに指定したりするとtemplateを最初にパースする時に404のHTTPリクエストが発生してしまうのでv-attrで指定する
* IEの場合styleにinvalidな属性を指定していると削除されるのでサポートするならv-styleで指定する

## Filters

* Viewに表示される前にpipeされてくる

## Components

* IDによって管理されるシンプルなViewModelのcostructor
* v-componentsとしてテンプレートで指定できる
* web componentsのように再利用性のあるもの

# Directives In Depth

## Synopsis

* angular.jsのDirectivesよりもシンプルでHTML属性としての埋め込みのみサポートしている

## A Simple Example

* v-xxx の形で定義される。v-textの場合はDOMのtext contentが更新されるとViewModelの値も更新される

## Inline Expressions

* 値には評価式を書くことが出来て、式が依存している値も自動的に追跡して更新される
* 非同期バッチで更新されて依存している複数の値が更新されても反映はイベントループ毎に一度にまとめて行われる
* templateにロジックを埋め込みすぎるのは避けるべきでvue.jsでは複数の式を書くことはできない
  * 代わりにComputed Propertiesを使うといい
* セキュリティ的な理由で式からはcurrentのViewModelとその親のPropertyとMethodしか参照することが出来ない

## Arguments

* 引数も指定できる

## Filters

* |でつなぐことでDOMが更新される前にフックさせる処理を書くことが出来る

## Multiple Clauses

* 1つのDirectiveに対してオブジェクト形式で複数のバインディングを定義することができる

## Literal Directives

* v-componentのようにデータバインディングでなくてリテラルを指定するものもある
* v0.10からリテラルにMustacheでの指定が出来るようになった
* しかしながらこれは最初に一度評価されるだけなので動的にしたい場合はv-viewを使うといい

## Empty Directives

* v-preのように属性値を指定しないものもある

## Writing a Custom Directive

* Vue.directiveを使ってカスタムDirectiveを作ることも出来る
* directive idと最初に一度呼ばれるbind、バインディングされてる値が更新される度に呼ばれるupdate、最後に一度だけ呼ばれるunbindを必要に応じて実装する
* updateだけ指定する時は第二引数に関数を直接指定することができる
* 定義した関数は中でthisから呼び出すことが出来て、thisには他にもel key args Expression vm valueなどが使えるようになっている

```html
<div id="demo" v-demo="LightSlateGray : msg"></div>
```
```javascript
Vue.directive('demo', {
    bind: function () {
        this.el.style.color = '#fff'
        this.el.style.backgroundColor = this.arg
    },
    update: function (value) {
        this.el.innerHTML =
            'argument - ' + this.arg + '<br>' +
            'key - ' + this.key + '<br>' +
            'value - ' + value
    }
})
var demo = new Vue({
    el: '#demo',
    data: {
        msg: 'hello!'
    }
})
```
```
argument - LightSlateGray
key - msg
value - hello!
```
* これらの値はreadonlyとして扱うべきで、オブジェクトにはプロパティを追加することもできるけど内部的な値を上書きしないように注意する必要がある

## Creating Literal & Empty Directives

* isLiteralかisEmptyをtrueにするとデータバインディングされずにbindとunbindだけが有効になる
* isLiteralの場合はExpressions key argが使えて、isEmptyでは何も渡されない

## Creating a Function Directive

* Vue.jsではデータと振る舞いを分けることを推奨していてdataの中にメソッドはない
* Directiveの中でメソッドを使いたい場合はisFnをtrueに指定する

# Filters in Depth

## Synopsis

* filterは|で定義することが出来て、値を処理して新しい値を返すことが出来る
* filterは引数を取ることも出来る

## Examples

* directiveの最後に指定したり、Mustacheバインディングで定義したり、filterをパイプでつないだり出来る

```html
<span v-text="message | capitalize"></span>
<span>{{message | uppercase}}</span>
<span>{{message | lowercase | reverse}}</span>
```

## Arguments

* 引数を取ることが出来るfilterはスペース区切りで引数を指定する

## Writing a Custom Filter

* カスタムfilterはVue.filter()で作ることが出来て第一引数にfilterIdを、第二引数に実装を書く
* 実装する関数は第一引数にfilterの対象が渡されて、第二引数以降にfilterに渡された引数があれば渡される

```javascript
Vue.filter('wrap', function (value, begin, end) {
    return begin + value + end
})
```

## Computed Filters

* filterの中でのcontextはfilterが定義されている要素のViewModelになっていて、ViewModelの状態によって動的に結果が変化する
* ViewModelとViewModelを参照しているfilterはComputed filtersとして結びつけられる
* Computed filtersがどのように動作してるのかわからなくてもVue.jsがいい感じにやってくれるので問題ない


# Displaying a List

* v-repeatでObjectやArrayの要素をViewModelとしてtemplateで繰り返し出力することができる
* 繰り返し処理の中では子要素だけでなく親要素も参照することが出来る
* 加えて$indexでindexの参照も出来る

## Arrays of Primitive Values

* 配列の要素がprimitiveな値の場合は、$thisで参照することが出来る

## Using an identifier

* 親要素を参照する場合など、子要素への参照をv-repeat="user: users"のようにして明示的にすることも出来る

## Mutation Methods

* vue.jsではArrayのpush、pop、shift、unshift、splice、sort、reverseをフックしてviewへ更新が反映される
* 配列に対してindexでの参照で更新するのはvue.jsで追跡されないので避けるべき
* そういった場合は$setや$removeを使うといい

### $set( index, value )

* 配列の指定したindexの要素を更新する

### $remove( index | value )

* spliceのsyntax sugarで指定した要素を削除する

## Setting a new Array

* filterなどnon-mutatingな新しい配列を返すようなメソッドの場合、全てのDOMが作り直されると思うかもしれないけど、Vue.jsは賢いから可能な限り再利用される

##Array Filters

* 実際のデータではなくて、表示上でfilterしたりsortしたい場合はfilterByやorderByといった標準のfilterを使うといい

## Iterating Through An Object

* v0.8.8からオブジェクトのpropertyをv-repeatで繰り返し処理出来るようになった
* $keyでkeyが参照できて、値がprimitiveの場合は$valueで、オブジェクトの場合はcontextに設定されるのでそのまま参照できる

## $add() and $delete()

* ECMAScript 5ではpropertyの追加・削除をフックすることが出来ないので、$add, $deleteを使って行うことでviewも更新される

# Listening for Events

* v-onのdirectiveでDOMイベントを購読することが出来る
* 関数名を書くか式を書くことも出来る
* 関数名を書く場合は引数にDOMのイベントオブジェクトが渡される
* またtargetVMというプロパティでイベントが発行されたViewModelを参照することも出来る

## Invoke Handler with Expression

* targetVMはv-repeatの中で使うと便利
* また定義する式の中でthisとしてViewModelを参照することも出来るのでその方がより使いやすいかも
* DOMイベントは定義する式の中で$eventとして参照することも出来る

## The Special key Filter

* keyboard入力を購読する時用にv-onでだけkeyというfilterを使うことが出来る
* **key | 13**のような形でも使ったり**key | enter**のように使ったり出来る

## Why Listeners in HTML?

* HTMLにイベントリスナーを定義するのは関心の分離に違反してると思うかもしれないけど、vue.jsのイベントハンドラは対象のViewに紐づいているViewModelによって処理されるのでメンテナンス性は下がらない
 * ちょっと何言ってるわからないみたいな役になってる...

* また次のようなメリットもある

1. JSの中に書くよりtemplateに書いた方がシンプルに定義出来る
1. JS内でイベント購読する処理を書かなくてよくなるので、DOMから解放されてロジックだけを書くことが出来てテストしやすくなる
1. ViewModelが破棄された時に全てのイベントリスナーも解除されるのでクリーンアップを考える必要がない


# Handling Forms

* v-modelを使うことでFormのような編集可能な2wayバインディングを作ることが出来る

# Computed Properties

* vue.jsのinline expressionsは便利だけど単純なbooleanや文字列結合以上のことをしたい場合はComputed Propertiyを使うべき
* Computed Propertyはcomputedオプションで定義出来る
* オブジェクトとして$get $setとしてゲッターセッターを定義する
* $getだけの場合はオブジェクトの値に直接実装することが出来る
* Computed Propertyは通常のプロパティと同じように扱うことが出来る

```javascript
var demo = new Vue({
    data: {
        firstName: 'Foo',
        lastName: 'Bar'
    },
    computed: {
        fullName: {
            // the getter should return the desired value
            $get: function () {
                return this.firstName + ' ' + this.lastName
            },
            // the setter is optional
            $set: function (newValue) {
                var names = newValue.split(' ')
                this.firstName = names[0]
                this.lastName = names[names.length - 1]
            }
        }
    }
})
demo.fullName // 'Foo Bar'
```

## Dependency Collection Gotcha

* inline expressionsようにComputed Propertyの依存関係も収集してくれる
* 依存関係の収集は$getで参照されたときに行われるので、条件分岐などで到達しないプロパティに対しては収集されないので条件に関係なく参照されるようにする必要がある
```javascript
status: function () {
    // access dependencies explicitly
    this.okMsg
    this.errMsg
    return this.validated
        ? this.okMsg
        : this.errMsg
}
```
* inline expressionsの場合はvue.jsがやってくれるので任せておけばいい


# Adding Transition Effects

* vue.jsで要素が追加、削除されたときにアニメーションさせるためのフックポイントが用意されている
* アニメーションはcss transitions、css animations、javascriptによるアニメーションの3つの選択肢がある
* アニメーションのtriggerはv-ifやvm.$appendToなどvue.js経由でDOM操作が行われた時だけ発行される

## CSS Transitions

* css transitionsを使いたい場合は要素にv-transitionを指定する
* v-transitionを指定した要素に要素が追加された時にはv-enter、削除された時にはv-leaveというclassが追加されるようになるのでそれを使ってアニメーションを記述する
* v-enterといった名前はVue.config()で変更できる

* 要素が非表示になるとき
 1. 要素のclassにv-leaveが追加される
 1. transitionendイベントが発行されるまで待つ
 1. 要素を削除してv-leaveも削除する

* 要素が表示されるとき
 1. 要素のclassにv-enterが追加される
 1. 要素がDOMに挿入される
 1. v-enterが追加されることでレイアウトが更新される
 1. v-enterが削除されて元の状態に戻る

transitionendイベントで状態が更新されるので、transitionendが発行されない場合は処理がされないので注意

## CSS Animations

* css animationsはtransitionsと似た方式を提供しているけどv-animationを使う
* 違いとしてはv-enterのクラスがDOMが挿入された後に即時に削除されずにanimationendのcallbackを待つ(???間違ってるかも)

## JavaScript Functions

* vue.jsは要素の追加、削除時に任意の関数を呼ぶことが出来る
* そのためにはVue.effectで関数を登録してアニメーションさせたい要素にv-effectで作成したeffectを指定する

```javascript
Vue.effect('my-effect', {
    enter: function (el, insert, timeout) {
        // insert() will actually insert the element
    },
    leave: function (el, remove, timeout) {
        // remove() will actually remove the element
    }
})
```

* 3つ目の引数(timeout)はsetTimeoutのラッパーで、エフェクトがキャンセルされた時にclearされるのでsetTimeout使いたい場合はこれを使う
 * http://qiita.com/koba04/items/4bb65dbb721008e72070


# Composing Components

## Registering a Component

* vue.jsではViewModelをweb componentsのように再利用性のあるものとして扱うことができる(polyfillなしで)
* componentを使うためにはまずVue.extendでコンストラクタを作って、それをVue.componentを使って登録する
* またVue.componentにプロパティをオブジェクトとして渡すことで直接作ることも出来る

```javascript
// Extend Vue to get a reusable constructor
var MyComponent = Vue.extend({
    template: 'A custom component!'
})
// Register the constructor with id: my-component
Vue.component('my-component', MyComponent)
```
```javascript
Vue.component('my-component', {
    template: 'A custom component!'
})
```

* するとcomponentを定義したViewModelのテンプレートの中で使うことが出来るようになる
 * componentはtop levelのViewModelがインスタンス化される前に登録される


```html
<div v-component="my-component"></div>
```
だけでなくカスタム要素として定義することも出来る
```html
<my-component></my-component>
```

* カスタム要素名で定義するときはnativeで定義されているものと衝突しないように注意する
 * そのためには要素名にハイフンを含める必要がある


* Vue.extendとVue.componentの違いを理解することは重要
 * VueはコンストラクタでVue.extendは継承のためのメソッドでVueのサブクラスのコンストラクタを返す
 * Vue.componentはVue.directiveのような登録を行うためのメソッド
 * String IDとコンストラクタを渡すことでテンプレートから使うことが出来るようになる
 * Vue.componentに直接オプションのオブジェクトを渡したときは裏でVue.extendが呼ばれている

* Vue.jsはBackboneのようなクラスによる継承ベースな仕組みとdirectiveのようなweb componentsのスタイルをサポートしている
* 混乱するかもしれないけど<img>とnew Image()の二通り、画像の要素の作り方があるようなもの
* どちらも便利なのでVue.jsではどちらもサポートすることで柔軟性を高めようとしている


## Data Inheritance

### Inheriting Objects from Parent as $data

* v-withを使うことで親要素のデータを継承することが出来る

```html
<div id="demo-1">
    <p v-component="user-profile" v-with="user"></p>
</div>
```
```javascript
// registering the component first
Vue.component('user-profile', {
    template: '{{name}}<br>{{email}}'
})
// the `user` object will be passed to the child
// component as its $data
var parent = new Vue({
    el: '#demo-1',
    data: {
        user: {
            name: 'Foo Bar',
            email: 'foo@bar.com'
        }
    }
})
```

### Inheriting Individual Properties with v-with

* v-withに引数が与えられたとき、子のcomponentの$dataに追加される
 * その場合親の要素とsyncし続ける

```html
<div id="parent">
    <p>{{parentMsg}}</p>
    <p v-component="child" v-with="childMsg : parentMsg">
        <!-- essentially means "bind `parentMsg` on me as `childMsg`" -->
    </p>
</div>
```
```javascript
new Vue({
    el: '#parent',
    data: {
        parentMsg: 'Shared message'
    },
    components: {
        child: {
            template: '<input v-model="childMsg">'
        }
    }
})
```

### Using v-component with v-repeat

* 配列のデータに対してはv-repeatとv-componentを組み合わせることができる
```html
<ul id="demo-2">
    <!-- reusing the user-profile component we registered before -->
    <li v-repeat="users" v-component="user-profile"></li>
</ul>
```
```javascript
var parent2 = new Vue({
    el: '#demo-2',
    data: {
        users: [
            {
                name: 'Chuck Norris',
                email: 'chuck@norris.com'
            },
            {
                name: 'Bruce Lee',
                email: 'bruce@lee.com'
            }
        ]
    }
})
```

### Accessing Child Components

* 時々、javascriptの中で子のcomponentのデータにアクセスしたくなることがあるかもしれない
* その場合、子のcomponentにv-refで参照するためのIDを書いておくとparent.$.xxuの形式で参照することが出来る
```html
<div id="parent">
    <div v-component="user-profile" v-ref="profile"></div>
</div>
```
```javascript
var parent = new Vue({ el: '#parent' })
// access child component
var child = parent.$.profile
```


## Event Communication Between Nested Components

* ViewModelは親子間で直接アクセスすることが出来るけど、異なるComponent間でのやりとりにはVue.jsのイベントを使ったほうがいい
* そうすることでメンテナンス性とコードを減らすことが出来る
* 一度ViewModelの親子関係が確立すると、$dispatchや$onなどのViewModelのイベント関連のメソッドでやりとりが出来る


## Encapsulating Private Assets

* 時々Componentをどこでも再利用できるようにカプセル化したくなることがあるかもしれない
* そういったときはインスタンスのオプションで指定することで、そのViewModelのインスタンスか子のComponentでしかアクセス出来ない値を作ることが出来る

```javascript
// All 5 types of assets
var MyComponent = Vue.extend({
    directives: {
        // id : definition pairs same with the global methods
        'private-directive': function () {
            // ...
        }
    },
    filters: {
        // ...
    },
    components: {
        // ...
    },
    partials: {
        // ...
    },
    effects: {
        // ...
    }
})
```
```javascript
MyComponent
    .directive('...', {})
    .filter('...', function () {})
    .component('...', {})
```

## Content Insertion Points

### Single insertion point

* 再利用性のあるComponentを作るとき、Component内の要素を使いたいことがある
* Vue.jsはWebComponentsのドラフト仕様と互換性のある要素を挿入する仕組みを持っていて、content要素をComponent内に挿入する場所として定義する
* 属性なしのcontent要素が1つだけ定義されている場合は、そこがComponent内の要素と置換される
* content要素内にはfallback要素を定義することが出来て、挿入する対象がない場合に使用される
```html
<h1>This is my component!</h1>
<content>This will only be displayed if no content is inserted</content>
```
```html
<div v-component="my-component">
    <p>This is some original content</p>
    <p>This is some more original content</p>
</div>
```
```html
<div>
    <h1>This is my component!</h1>
    <p>This is some original content</p>
    <p>This is some more original content</p>
</div>
```
### Multiple insertion points and the select attribute

* content要素はselect属性を持つことが出来て、css selectorを指定することが出来る
* 複数のcontent要素を指定する場合は、select属性にそってどのcontentを置換するか指定することが出来る
```html
<content select="p:nth-child(3)"></content>
<content select="p:nth-child(2)"></content>
<content select="p:nth-child(1)"></content>
```
```html
<div v-component="multi-insertion-component">
    <p>One</p>
    <p>Two</p>
    <p>Three</p>
</div>
```
```html
<div>
    <p>Three</p>
    <p>Two</p>
    <p>One</p>
</div>
```


# Building Larger Apps

* Vue.jsは可能な限り柔軟に設計されている
 * ただのライブラリで他のアーキテクチャと衝突しないように
* プロトタイプを素早く作るときに便利
* 大規模なアプリケーションをVue.jsを使って作ろうと思うかもしれないのでここではその方法について説明する

## Build with Component

* Vue.jsは[Component](https://github.com/component/component)というフロントエンドのパッケージマネージャー＆ビルドツールを使って構築されている
* Compomentを使うとブラウザでもCommonJSスタイルで書くことが出来て、Githubにpushすることで簡単にモジュールを公開することが出来る
 * サンプルはこちら https://github.com/vuejs/vue-component-example
* すでに下記にたくさんのComponentが公開されているので、フロントエンド開発の一般的な問題に対しては役に立つ
 * https://github.com/component/component/wiki/Components
* 大規模なアプリケーションを作るときは、Vue.jsをインターフェイスとして、足りない機能をComponentで公開されているライブラリを使う形になる

* また、Browserifyという素晴らしいビルドライブラリもあって、こちらはGithubではなくてnpmを使っていてコミュニティも盛り上がっている
 * http://browserify.org/

## Modularization

* ComponentはJavaScriptのビルドだけでなくCSSやTemplateなどのassetのビルドも出来る
* またビルドをフックすることでCoffeeScriptやSassやStylusを使う事もできる
* その結果、JavaScriptとCSSとHTMLをカプセル化してCompomentとして扱うことが可能になる
 * https://github.com/vuejs/vue-component-example
* 似たようなことはBrowserifyでもpartialifyのようなtransformのpluginを使うことで可能
 * https://github.com/vuejs/vue-browserify-example

## Routing

* 基本的なRoutingはhashchangeイベントとv-view directiveを使って実装することが出来る
* v-view directiveはcomponentを動的にロードするのに効果的
* componentのIDをバインドすることで新しいViewModelのインスタンスが生成されて、古いViewModelは削除される

```html
<div id="app">
    <div v-view="currentView"></div>
</div>
```
```javascript
Vue.component('home', { /* ... */ })
Vue.component('page1', { /* ... */ })

var app = new Vue({
    el: '#app',
    data: {
        currentView: 'home'
    }
})
```

* v-viewは要素を新しいViewModelで置換するので、rootの要素で指定するのは避けたほうがいい
* v-viewは [Page.js](https://github.com/visionmedia/page.js)や[Director](https://github.com/flatiron/director)といったライブラリと簡単に組み合わせることが出来る
* また、Routingを簡単に出来るvue-routerを提供する予定もある

## Communication with Server

* ViewModelはJSON.stringifyでシリアライズされた$dataを持っている
* ajaxのcomponentは[SuperAgent](https://github.com/visionmedia/superagent)のような好みのものをつかう事が出来る
* またFirebaseのようなサービスをバックエンドにすることも出来る
* またAngular.jsの$resourceのようなREST APIのクライアントもvue-resourceとして提供する予定

## Unit Testing

* Componentを使うと、ViewModelやdirectiveやfilterをCommonJSのモジュールとして分割することが出来る
* Componentベースのプロジェクトはstandalone flagが立ってrequireメソッドがexportされて、内部モジュールにアクセスすることが出来る
* これによってテストとテスト対象を含んだビルドを作ってブラウザでのユニットテストが簡単にできるようになる
* ベストプラクティスはメソッドが含まれた生のオブジェクトをexportすること
```javascript
// my-component.js
module.exports = {
    created: function () {
        this.message = 'hello!'
    }
}
```
```javascript
// main.js
var Vue = require('vue')

var app = new Vue({
    el: '#app',
    data: { /* ... */ },
    components: {
        'my-component': require('./my-component')
    }
})
```
```javascript
// Some Mocha tests
// using a non-standalone build of the project
describe('my-component', function () {
    
    // require exposed internal module
    var myComponent = require('my-project/src/my-component')
    it('should have a created hook', function () {
        assert.equal(typeof myComponent.created, 'function')
    })
    it('should set message in the created hook', function () {
        var mock = {}
        myComponent.created.call(mock)
        assert.equal(mock.message, 'hello!')
    })
})
```

* Vue.jsのバインディングは非同期に行なわれるので、更新後のDOMの値を確認するときはVue.nextTick()を使う必要がある


# Plugins

**これはpreview版なのでAPIなどに変更があるかもしれない**

* こんな感じで使う

```javascript
// assuming using a CommonJS build system
var vueTouch = require('vue-touch')
// use the plugin globally
Vue.use(vueTouch)

// Extended components can use plugins too!
var awesomePlugin = require('vue-awesome'),
    MyComponent = Vue.extend({})
MyComponent.use(awesomePlugin)

// arguments
Vue.use('vue-touch', { moveTolerance: 12 })
```
* Componentだと↓のような使い方も出来る
```javascript
// will auto require('vue-touch')
Vue.use('vue-touch')
```

## Plugin Implementation

* 渡されるVueのコンストラクタはVueを継承したComponentかもしれない
* 中ではVue.requreとメソッドの登録だけが出来る。Vue.configをPluginの中でVue.configを使用してはいけない

```javascript
exports.install = function (Vue, options) {
    // use Vue.require to access internal modules
    var utils = Vue.require('utils')
}
```

# written by koba04
thx!
