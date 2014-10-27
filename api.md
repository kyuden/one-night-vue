# API

* source
  * http://vuejs.org/api/

# Class: Vue

* Vueはvue.jsのコアとなるコンストラクタ
* インスタンスが作られたときにデータバインディングが開始される
* オプションを取ることも出来て、DOMやデータやメソッドについて定義出来る

* コンパイルフェイズでは、DOMやdirectiveの内部を捜査する
* 一度コンパイルされるとViewModelによって管理される
* 一つのDOMを管理出来るのは一つのViewModelだけ
* すでにコンパイルされている要素に対して再度ViewModelを作ったりしてコンパイルすると既存のバインディングの情報が失われるので、コンパイル済みの要素に対して再度コンパイルすべきではない
* テンプレートの要素はDocumentFragmentsによってキャッシュされて効率的に再利用される

* ViewModelのインスタンスは$elによってDOMと関連付けられる(MVVMのV)
* また$dataによっても関連付けられる(MVVMのM)
* それぞれは双方向にバインディングされる

* ViewModelのインスタンスは$dataへのアクセスをプロキシしていて、vm.$data.msgはvm.msgとして参照出来る
* しかしながらそこには違いがあってvmの形式では他のViewModelをdataとして扱うことは出来ない
 * おそらくViewModelのdataに他のViewModelを指定すると、ViewModelの指定された側のViewModel側には変更が反映されないことを言っている？
 * http://jsfiddle.net/koba04/PY2Q2/
* dataオブジェクトは一つのViewModelだけに属している必要はなくて複数のViewModelから参照することも出来る
* これは複数のcomponentがグローバルなオブジェクトを共有して反応する必要があるときに便利

* ViewModelはいくつかのメソッドを持っていてデータやイベントやDOMを操作するのに使える
* また、Vueのコンストラクタ自身もいくつかのメソッドを持っていて、Vueを継承したりグローバルな設定やdirectiveやcomponentを登録することが出来る

# Instantiation Options

## Data & Logic

### data

* ViewModelのデータでvm.$dataとしてアクセス出来る
* ViewModelのプロパティへのアクセスはdataにプロキシされて同期される
* データオブジェクトはJSONとして表現出来る必要がある
* 複数のViewModelでデータを共有することが出来る

* Vue.jsは\_\_emitter\_\_という隠しプロパティを持っていてプロパティへのgetter、setterでイベントを発行する
 * $と_で始まるプロパティはスキップされる

### methods

* ViewModelにミックスインされてViewModelインスタンスから直接アクセスすることが出来、directiveから呼ぶことも出来る
* メソッドのcontextはViewModelのインスタンスになる

### computed

* getter($get)、setter($set)を定義しておくことで常に処理済みの値を返すことが出来る

```javascript
var vm = new Vue({
    data: { a: 1 },
    computed: {
        // get only, just need a function
        aDouble: function () {
            return this.a * 2
        },
        // both get and set
        aPlus: {
            $get: function () {
                return this.a + 1
            },
            $set: function (v) {
                this.a = v - 1
            }
        }
    }
})
vm.aPlus // 2
vm.aPlus = 3
vm.a // 2
vm.aDouble // 4
```

### paramAttributes

* ViewModelに処理データとしてセットするattributeの配列
* これが評価されるのは1度のみで、ViewModelでの変更がこの属性に反映されることはない

```html
<div id="test" size="100" message="hello!"></div>
```
```javascript
new Vue({
    el: '#test',
    paramAttributes: ['size', 'message'],
    created: function () {
        console.log(this.size) // 100
        console.log(this.message) // 'hello!'
    }
})
```

## DOM Element

### el

* ViewModelに紐付けるDOM要素でquerySelectorの書式で指定する
* vm.$elで参照することが出来る
* これが指定されていない場合は新しいDOMのnodeが自動的に作成される

### template

* $elに挿入されるtemplateの文字列で、$elにあった要素は全て上書きされる
* replaceオプションがtrueの場合は上書きではなくて置き換えられる
* \#から始まっている場合はquerySelectorとして評価されて、取得した要素がテンプレートととして使用される

* Vue.jsはDOMベースのテンプレートでコンパイラーはDOMからdirectiveを探してデータバインディングを作る
* 文字列のテンプレートの場合もDOMFragmentにしてインスタンス毎にcloneされる
* ValidなHTMLにしたい場合はdata-属性として指定することも出来る

### replace

* テンプレートでトップレベルの要素を置き換えるかどうか

### tagName

* 作成される要素のタグの名前

### id

* 要素のid

### className

* 要素のクラス名

### attributes

* 要素の属性値


## Lifecycle Hooks

* ViewModelのインスタンスのライフサイクルに応じて'attached', 'detached', 'beforeDestroy', 'afterDestroy'といったイベントが発行される
* イベントは'hook:eventName'の形式で発行される

### created

* コンパイルが始まる前に同期的に呼ばれる
* $elや$dataは使えるけどDOMはまだ準備出来ていないのでデータバインディングはまだ有効でない
* createdのフックはViewModelの初期状態に何か追加したい場合に使われる
* createdのフックの中でセットした関数でないプロパティは後ほどdataオブジェクトにコピーされてデータバインディングが開始される
* createdのフックの中で$watchを使う場合はデータが作られたときにも呼ばれるので変更されたときだけに呼んで欲しい場合はreadyのフックの中で使うといい

### ready

* コンパイルも終わってViewModelの準備出来たときに呼ばれる
* readyのフックの中でプロパティを追加した場合はデータバインディングの対象にならないので注意(createdを使う)

### attached

* $elがdirectiveやインスタンスメソッドでDOMにattachされたタイミングで呼ばれる
* $elを直接操作した場合は呼ばれない

### detached

* $elがdirectiveやインスタンスメソッドでDOMから削除されたタイミングで呼ばれる
* $elを直接操作した場合は呼ばれない

### beforeDestroy

* ViewModelが破棄されるときに呼ばれて、データバインディングやdirectiveはまだ有効な状態になっている
* また全ての子ViewModelも有効な状態
* このフックはほとんど内部的に使われているものだけどcreatedやreadyのフックのクリーンアップで使うことはあるかもしれない
* $onや$watchは$destroyの中で解除してくれるので明示的に呼ぶ必要はない

### afterDestroy

* ViewModelが完全に破棄された後に呼ばれる
* データバインディングなども解除されている

## Private Assets

* ViewModelのコンパイルの時のみ有効なプロパティ

### directives

* ViewModelで使用できるdirective

### filters

* ViewModelで使用できるfilter

### components

* ViewModelで使用できるcomponent

### partials

* ViewModelで使用できるpartial

### transitions

* ViewModelで使用できるtransition

## Others

### parent

* 親のViewModelのインスタンス
* これはv-componentを使うのと同じようなメリットがあって親のスコープのデータをテンプレートの中で利用できる
* 親のViewModelをvm.$parentとして参照出来る
* 親子間でイベントを通じてやりとり出来る
* 親が破棄された時に子も一緒に破棄される

このオプションはネストしたViewModelを扱う時にメモリ管理を行いたい時に便利

### lazy

* changeイベント(enterキー押すかフォーカスが外れる)だけでtriggerされるか全てのinputイベント(キー入力)でtriggerされるか
 * inputタグとかの話？


# Instance Properties

### vm.$el

* ViewModelが管理しているDOM

### vm.$data

* ViewModelがバインディングしているデータ
* 新しいオブジェクトに差し替えることも出来る
* ViewModelのプロパティのようにアクセスすることも出来る

### vm.$options

* ViewModelをインスタンス化したときのオプション
* カスタムオプションを指定した時はここから参照する

### vm.$

* v-refで指定したオブジェクトが入っている

### vm.$index

* v-repeatの中で使うとインデックスが入っている

### vm.$parent

* 親のViewModel

### vm.$root

* rootのViewModel

### vm.$compiler

* ViewModelのコンパイラーのインスタンス
* 内部的にViewModelのデータバインディングの管理などをしているもので、基本的には使うのを避けるべき


# Instance Methods

## Data

* データに対する変更の監視は全て非同期で行われる
* 加えて変更の反映はイベントループの中でバッチとして行われる
* ということで、同じイベントループの中で複数回データを変更してもデータご更新されるのは最新の値で一度だけ

### vm.$watch( keypath, callback )

* 指定したkeypathのデータの変更を監視してコールバックを実行する
* コールバックには第一引数で新しい値が渡されている

### vm.$unwatch( keypath, [callback] )

* 変更の監視をやめる
* コールバックを渡すと監視をやめたタイミングで呼ばれる(?)

### vm.$get( keypath )

* 与えられたkeypathから値を取得する
* 与えられたkeypathのデータが見つからなかった時は見つかるまで親のViewModelを辿っていく
* どの親がデータを持っているかわからないときなどに便利
* 見つからなかった場合はundefinedを返す

### vm.$set( keypath, value )

* 指定したkeypathにデータをセットする
* keypathが存在しなかった場合は作成される

## Cross-ViewModel Events

* 複数のネストしたViewModelがあるとき、EventEmitterのようにお互いやりとり出来る

### vm.$dispatch( event, [args...] )

* イベントを発行する
* イベントは$rootまで遡って伝わっていく

### vm.$broadcast( event, [args...] )

* 全ての子のViewModelにイベントを発行する
* 子のViewModelのさらに子にも伝わっていく

### vm.$emit( event, [args...] )

* ViewModel自身に対してのみイベントを発行する

### vm.$on( event, callback )

* ViewModelのイベントを購読する

### vm.$once( event, callback )

* ViewModelのイベントを一度だけ購読する

### vm.$off( [event, callback] )

* 引数がない時は全てのイベントを解除する
* イベントが与えられた時はそのイベントだけが解除される
* イベントとコールバックが与えられた時はそのイベントの指定されたコールバックだけ解除される

## DOM Manipulation

* 全てのDOM操作はjqueryと同じように動作する
* vue.jsのtransitionのtriggerが発行されることを除いて

### vm.$appendTo( element | selector )

* vm.$elに指定されたelementを追加する。querySelectorの文字列でも大丈夫

### vm.$before( element | selector )

* vm.$elの前にelementを追加する

### vm.$after( element | selector )

* vm.$elの後にelementを追加する

### vm.$remove()

* DOMから$elを削除する

## Misc

### vm.$destroy()

* 完全にViewModelを破棄する
* 他のViewModelとの連携、directive、DOM、$onや$watchのイベントリスナなども自動的に破棄される


# Global Methods

### Vue.extend( options )

* Vueのサブクラスを作る
* elを除くViewModelをインスタンス化する際のオプションのほとんどを使える
* elは同じ要素に対して複数のViewModelを割り当てることは出来ないのでインスタンス化する際にしか指定出来ない

### Vue.config( options | key, [value] )

* グローバルなオプション。複数回呼ぶことが出来て値は上書きされる

* デフォルト

```javascript
{
    // prefix for directives
    prefix: 'v',
    // log debug info
    debug: false,
    // suppress warnings
    silent: false,
    // CSS class attached for entering transition
    enterClass: 'v-enter',
    // CSS class attached for leaving transition
    leaveClass: 'v-leave',
    // Interpolate mustache bindings
    interpolate: true,
    // Interpolation delimiters
    // default value translates to {{ }} and {{{ }}}
    delimiters: ['{', '}']
}
```

### Vue.directive( id, [definition] )

* グローバルにdirectiveを登録する

### Vue.filter( id, definition )

* グローバルにfilterを登録する

### Vue.component( id, definition )

* グローバルにcomponentを登録する

### Vue.effect( id, definition )

* グローバルにtransition effectを登録する

### Vue.partial( id, definition )

* グローバルにpartialを登録する
* テンプレートのHTMLか#から始まっている場合はquerySelectorとして評価され、DOM elementを指定することが出来る

### Vue.nextTick( callback )

* Vue.jsはバッチでViewの更新を非同期で行う
* nextTickは内部ではrequestAnimationFrameが使えるときは使って、使えない時はsetTimeout 0で呼ばれる
* このメソッドは次のViewの更新を待って処理を実行したい時に便利

### Vue.require( module )

* Vue.jsが内部で使用しているモジュールにアクセスすることが出来る
* プラグインの作成する時に使用するけど注意して使う必要がある

### Vue.use( plugin, [args...] )

* プラグインを使う
* プラグインはオブジェクトでinstallメソッドを持っている必要がある
* 関数として定義されていた場合はそれがinstallメソッドとして扱われる
* 引数はinstallメソッドに渡される


# Directives

## Data Binding Directives

* これらのdirectiveはViewModelのプロパティにバインドされる
* またViewModelのコンテキストで式が評価される

### v-text

* elementのtextNodeとして更新される
* {{ Mustache }}で書いた場合もv-textとしてコンパイルされる

### v-html

* elementのinnerHTMLとして更新される
* ユーザーの入力をv-htmlで使うのは危険で安全なデータに対してのみ使うべき

### v-show

* このdirectiveはtransitionのtriggerを発行する
* バインディングされた値がtrueとして評価される値でない場合はdisplay noneになる
* それ以外の場合はオリジナルの値

### v-class

* 引数がない場合はバインディングされた値がclassListに追加される
* 引数が与えられた場合はバインディングされた値によってクラスがtoggleされる

```html
<span v-class="
    red    : hasError,
    bold   : isImportant,
    hidden : isHidden
">
```

### v-attr

* 引数が必須のdirectiveで、指定された属性の値をセットする

```html
<canvas v-attr="width:w, height:h"></canvas>
```

* 属性の内部で{{ Mustache }} 使った場合はv-attrとしてコンパイルされる
* img srcを指定する場合はMustacheではなくてv-attrで指定すべき
* そうしないとブラウザが評価した時にMustache形式のままHTTPリクエストを発行して404が起きてしまう

### v-style

* インラインでCSSを指定できる
* 引数が与えられなかった場合はel.style.cssTextの値がセットされる
* 引数が与えられた場合はCSSのスタイルとして設定される

```html
<div v-style="
    top: top + 'px',
    left: left + 'px',
    background-color: 'rgb(0,0,' + bg + ')'
">
```

* 指定するプロパティを$から始めるとVue.jsが自動的にprefixをつけてくれる
* $transformと指定するとtransform、webkitTransform、mozTransform、msTransformを付けてくれる

* IEはHTMLをパースする時にinvalidなstyle指定を削除するのでMustache形式の指定ではなくてv-styleで指定した方がいい

### v-on

* 関数か式を引数で指定する必要がある
* イベントリスナーを要素に登録する
* イベントのタイプは引数で指定する
* key filter(キー入力のfilter)と一緒に使うことが出来る

### v-model

* 編集可能な要素に対して双方向データバインディングを提供する
* このdirectiveはinputやselectやtextareaなど編集出来る要素でのみ使うことが出来る
* データは常に同期されるけどlazyオプションを指定した時にはchangeイベントのタイミングで同期される
* 詳しくはHandling Formsの項目を

### v-if

* このdirectiveは子のViewModelを作る
* transitionのtriggerを発行する
* バインディングされた値がtrueな値かどうかによって要素が挿入、削除される
* 初期値がfalseな値の場合、子のViewModelはtrueになるまで作られない

### v-repeat

* このdirectiveは子のViewModelを作る
* このdirectiveは配列の値を必要とする
* transitionのtriggerを発行する
* バインディングされた配列の各要素毎に子のViewModelを作る
* 作成された子のViewModelはpushなどの配列を操作するメソッドによって自動的に挿入、削除される
* 引数が与えられなかった時はViewModelの$dataを配列として扱う
* この値がオブジェクトてなくて単なる値の場合は$valueとしね参照することが出来る

* 引数が一つ与えられた場合は、指定されたViewModelのプロパティを対象とする
* またuser : usersのようにプロパティへのアクセスを明示的にすることも出来る

### v-view

* このdirectiveは子のViewModelを作る
* transitionのtriggerを発行する
* 指定された値をComponentIDとして探して構築する
* 値が変更された時は既にあったViewModelの値は破棄されて新しいViewModelが作成される
* また、元々のelementも置き換えられるがすべての属性は新しい要素にコピーされる

### v-with

* このdirectiveは子のViewModelを新しく作成する
* このdirectiveはkeypathのみを受け付ける
* 親のViewModelのデータから新しくViewModelを作ることが出来る
* 指定したkeypathのオブジェクトをdata optionで渡しているかのように何も付けずに参照出来る(要するにwith)
* また親のViewModelとは違う値で参照するようにも出来る

```html
<div v-with="myName : user.name, myEmail: user.email">
    <!-- you can access properties with the new keys -->
    {{myName}} {{myEmail}}
</div>
```

## Literal Directives

* Literal Directivesはその属性値をただの文字列として扱う
* bind()メソッドが一度だけ実行される
* 値にmustache形式で指定することはできるけど評価されるのは一度だけなのでその後に変更しても反映されない

### v-component

* 指定されたComponentを子のViewModelとしてコンパイルする
* v-withと組み合わせて親のViewModelのデータを使用することも出来る

### v-ref

* v-component、v-with、v-repeatと一緒に使われていないときは無視される
* 登録すると親のViewModelからv-refで指定したViewModelをvm.$.[v-refで登録した値]で参照できるようになる
* v-repeatと一緒に使うとそれぞれの要素の子ViewModelと関連付けできるようになる
 * (親からViewModelとして各要素を参照出来るようになるのがメリット？)

### v-partial

* 登録されたpartialで置き換える
* partialはVue.partial()で登録するか、partialsのオプションで指定出来る
* {{> partial_name}}の形式でも使うことが出来る

### v-effect

* JavaScriptによるeffectを要素に登録する
* JavaScriptによるeffectはVue.effect()かeffectsのオプションで指定出来る


## Empty Directives

Empty Directivesは属性値を指定しても意味なくて無視される

### v-transition

* CSS Transitionを使用する要素であることをVue.jsに通知する
* CSS Transtionのtriggerを発行するdirectiveの状態が変化したときや、DOM操作メソッドによってDOMが変化したときにtransitionのクラスが要素に追加される

### v-animation

* CSS Animationを使用する要素であることをVue.jsに通知する

### v-pre

* 指定された要素とその子要素のコンパイルをスキップする
* directiveが指定されていないたくさん子要素を持っている要素に指定してスキップさせることでコンパイルの速度をあげることが出来る

### v-cloak

* この属性は関連する要素のコンパイルが終わるまでが残り続ける
* [v-cloak] { display: none } のようなCSSと組み合わせて使うことで、コンパイルが終わっていない{{mustache}}が表示されてしまうのを防ぐことが出来る


#Filters

### capitalize

* 'abc' => 'Abc'

### uppercase

* 'abc' => 'ABC'

### lowercase

* 'ABC' => 'abc'

### currency

* 12345 => $12,345.00

* 引数で通貨の記号を指定することも出来る

### pluralize

* 引数が一つの時は値が複数であれば引数の文字列にsをつけてくれる
* 引数で配列を渡すと値によって対応した配列の文字列が使われる
  * val - 1を配列のindexとして使う
* 値が配列の要素数より大きい場合は最後の値が使われる

```html
<span v-text="date | st nd rd th"></span>
Will result in:
1 => '1 st'
2 => '2 nd' 3 => '3 rd' 4 => '4 th' 5 => '5 th'
```

### key

* このfilterはv-onとの組み合わせでのみ有効で引数を一つ受け取る
* 指定したkeycodeにマッチするかでv-onのイベントハンドリングをフィルタすることが出来る
* keycodeとして下記のようなエイリアスを使うことが出来る
 * enter
 * tab
 * delete
 * esc
 * up
 * down
 * left
 * right

```html
<input v-on="keyup:doSomething | key enter">
```

### filterBy

* v-repeatとの組み合わせでのみ有効
* v-repeatで表示するデータを引数で指定したViewModelの値でフィルタリングすることが出来る
* またin propertyの様に検索するプロパティを指定することも出来る

```html
<input v-model="searchText">
<ul>
    <li v-repeat="users | filterBy searchText in name">{{name}}</li>
</ul>
```

* 引数の指定をシングルクォーテーションで囲むことで値を直接指定することも出来る


### orderBy

* v-repeatとの組み合わせでのみ有効
* v-repeatの結果をソートする
* 指定するソートのキーはViewModelのコンテキストで評価される
* reserseKeyとしてpropertyを指定することが出来て、指定されたkeyの値がtrueでない場合は、reserver sortになる
* sort keyをシングルクォーテーションで囲むことも出来て、reserver sortであることを示すためにreverseKeyに-1を指定することも出来る

```html
<ul>
    <li v-repeat="users | orderBy field reverse">{{name}}</li>
</ul>
```

# written by koba04
thx!
