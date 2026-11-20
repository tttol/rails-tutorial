# Ruby on Rails 入門コース：NeovimでHello Worldまで

対象：Ruby・Railsを初めて学ぶ方  
ゴール：自分で作ったRailsのページをブラウザで表示し、表示までの流れを説明できること  
目安：2〜3時間＋初回インストール時間  
資料確認日：2026年11月14日（UTC）  
教材の対象：Ruby 3.4系 / Rails 8.1系 / macOSまたはUbuntu 22.04以降

> OSは未指定のため、macOSとUbuntuの手順を用意しました。該当する方だけ実施してください。ほかのLinuxではパッケージ名・導入方法が異なります。Windowsの場合はWSL2上のUbuntuで学ぶ方法があります。
>
> この教材のコマンドをお使いのPCに実行する作業は、まだ行っていません。作成環境にRuby・Railsがないため、公式資料との照合と手順の静的確認まで実施しています。実機での動作確認は各章のチェックに沿って行ってください。

## 目次

1. ゴールと学習順序
2. Lesson 1：開発環境を用意する
3. Lesson 2：Neovimでファイルを編集する
4. Lesson 3：Rubyの最小限を覚える
5. Lesson 4：Railsアプリを作る
6. Lesson 5：Hello Worldを表示する
7. Lesson 6：仕組みを確認し、自分で変更する
8. 任意：自動テストを1本書く
9. つまずいたときの確認表
10. 完了チェックと公式資料

## 1. ゴールと学習順序

完成すると、`http://localhost:3000/` に次の見出しが表示されます。

```text
Hello World!
Neovimで作った最初のRailsページです。
```

| 順序 | 学ぶこと | 完了条件 | 目安 |
| --- | --- | --- | --- |
| 1 | Ruby・Rails・エディタの準備 | バージョンが表示される | 30〜60分以上 |
| 2 | Neovimの基本操作 | 保存して終了できる | 10分 |
| 3 | Rubyの文法 | ターミナルで挨拶を出せる | 20分 |
| 4 | Railsアプリの作成 | 開発サーバーが動く | 15分 |
| 5 | URL・処理・画面の接続 | Hello Worldが見える | 20分 |
| 6 | 自力で変更と説明 | 表示文言を変えられる | 15分 |

今回は、データ登録、認証、Docker、デプロイ、JavaScriptのビルド、Neovimプラグイン設定は扱いません。最初は「画面に届くまでの仕組み」だけに集中します。

### 最初に区別する言葉

- **Ruby**：プログラミング言語です。
- **Rails**：RubyでWebアプリを作るためのフレームワークです。
- **gem**：Rubyのライブラリやツールのパッケージです。Rails自体もgemです。
- **Bundler**：アプリごとのgemの依存関係を管理するツールです。
- **Neovim**：コードを書くエディタです。RubyやRailsの実行環境とは別です。
- **ターミナル**：コマンドを実行する画面です。Neovimの中にいるときと区別してください。

## 2. Lesson 1：開発環境を用意する

### 方針

OS標準のRubyではなく、バージョン管理ツールのmiseを使用します。既にrbenv・asdf・mise等を利用中なら、別の管理ツールを重ねて入れず、その環境でRuby 3.4系を選んでください。

Rails 8.1はRuby 3.2以上が前提です。本教材では学習環境を揃えるためRuby 3.4系とRails 8.1系を選びます。「最新の全バージョン」という意味ではありません。パッチ番号は導入時点のものになります。

公式根拠：[Railsのインストール](https://guides.rubyonrails.org/install_ruby_on_rails.html)、[Rails入門の前提条件](https://guides.rubyonrails.org/getting_started.html#prerequisites)。

### A. macOSの場合

ターミナルで実行します。既に導入済みのものは飛ばしてください。Homebrewの現行サポート対象はmacOS 15以降です。古いmacOSでは先に公式の対応状況を確認してください。

```bash
xcode-select --install
```

表示される画面でCommand Line Toolsの導入を完了してください。Homebrewが未導入なら、[Homebrew公式](https://brew.sh/)の手順で導入し、終了時に表示されるPATH設定を実施します。Apple SiliconとIntelでインストール先が異なるため、ここではPATHを固定しません。

```bash
brew install openssl@3 libyaml gmp rust sqlite3 mise neovim
```

標準のzshを使う場合、`~/.zshrc`に次の行を**1回だけ**追加します。既に同等の設定があれば追加不要です。

```bash
eval "$(mise activate zsh)"
```

その後、新しいターミナルを開きます。

### B. Ubuntuの場合

```bash
sudo apt update
sudo apt install -y build-essential rustc libssl-dev libyaml-dev zlib1g-dev libgmp-dev git curl sqlite3 libsqlite3-dev neovim
```

miseは[公式インストール手順](https://mise.jdx.dev/getting-started.html)から導入します。公式のインストールスクリプトを使う場合は次のとおりです。外部スクリプトの実行になるため、リンク先の内容と配布元を確認してから実行してください。

```bash
curl https://mise.run | sh
```

bashを使う場合、`~/.bashrc`に次の行を**1回だけ**追加し、新しいターミナルを開きます。

```bash
eval "$(~/.local/bin/mise activate bash)"
```

zshの場合は`~/.zshrc`に設定し、末尾を`activate zsh`とします。

### C. 共通：学習専用フォルダにRubyを設定する

以降はmacOS・Ubuntuで共通です。既存プロジェクトと混ざらない専用フォルダを作ります。

```bash
mkdir -p ~/projects/rails-learning
cd ~/projects/rails-learning
mise use ruby@3.4
ruby --version
which ruby
```

`ruby 3.4.x`が表示されれば進めます。`x`は実際のパッチ番号です。`mise use`はこのフォルダの設定を作り、その配下で使用するRubyを選びます。`/usr/bin/ruby`が選ばれる場合は、miseの有効化を見直してください。

```bash
gem install bundler
gem install rails -v '~> 8.1.0'
rails --version
bundle --version
nvim --version
sqlite3 --version
```

`Rails 8.1.x`が表示されることを確認します。`~> 8.1.0`は8.1系の範囲を指定する書き方です。既に別系統のRailsがあり、違うバージョンが選択された場合は後述のトラブル表を参照してください。

**完了チェック**

- [ ] Ruby 3.4系・Rails 8.1系・Bundler・Neovimのバージョンを確認しました。
- [ ] `sudo gem install ...`を使わずに導入できました。
- [ ] 学習用フォルダにいます。

## 3. Lesson 2：Neovimでファイルを編集する

この教材ではプラグイン不要です。ターミナルを2つ用意し、片方を編集、もう片方をRailsサーバー用にすると迷いにくくなります。

ターミナルで実行します。

```bash
cd ~/projects/rails-learning
nvim hello.rb
```

1. `i`を押し、入力モードにします。
2. 次の1行を入力します。
3. `Esc`を押して通常モードに戻ります。
4. `:wq`と入力してEnterを押し、保存して終了します。

```ruby
puts "Hello World!"
```

ターミナルに戻ったら実行します。

```bash
ruby hello.rb
```

期待する表示：

```text
Hello World!
```

### このコースで使う操作

| 操作 | キー／コマンド |
| --- | --- |
| 入力を始める | `i` |
| 通常モードに戻る | `Esc` |
| 保存する | `:w` → Enter |
| 保存して終了する | `:wq` → Enter |
| 変更を捨てて終了する | `:q!` → Enter。未保存の変更は失われます |
| 直前の編集を戻す | 通常モードで`u` |
| ファイル先頭に移動 | 通常モードで`gg` |
| ヘルプを読む | `:help` → Enter |

既存ファイルの全置換を行うときは、まず内容を確認してください。この教材で新規作成したファイルだけなら、通常モードで`ggdG`とすると全行を削除できます。その後`i`で新しい内容を入力します。

公式資料：[Neovimの最初の操作](https://neovim.io/doc/user/usr_02/)。

## 4. Lesson 3：Rubyの最小限を覚える

`hello.rb`を次の内容に変更してください。この章はRailsの外で、Rubyそのものを学びます。

```ruby
name = "World"

def greeting(name)
  "Hello #{name}!"
end

puts greeting(name)
puts greeting("Ruby")
```

```bash
ruby hello.rb
```

期待する表示：

```text
Hello World!
Hello Ruby!
```

読み方：

- `name = "World"`：変数に文字列を代入します。型名は書きません。
- `def ... end`：メソッドを定義します。
- `#{name}`：ダブルクォートの文字列に値を埋め込みます。
- メソッド内の最後の式が返り値になります。この例では`return`を省略しています。
- `puts`：ターミナルに出力します。ブラウザに表示する命令ではありません。

### Railsで見る形にも触れる

次のコードをファイル末尾に追加します。

```ruby
class Greeting
  def initialize(name)
    @name = name
  end

  def message
    "Hello #{@name}!"
  end
end

puts Greeting.new("Rails").message
```

- `class ... end`：クラスの定義です。
- `new`でオブジェクトを作ると、`initialize`が初期化を行います。
- `@name`は、そのオブジェクトが保持するインスタンス変数です。
- `object.message`のように、`.`を使ってメソッドを呼び出します。

実行すると最後に`Hello Rails!`が追加されます。

**小課題**：`"Rails"`を自分の好きな文字列に変えて、結果を予想してから実行してください。

公式資料：[Ruby公式入門](https://www.ruby-lang.org/en/documentation/quickstart/)。今はすべての文法を覚えなくても大丈夫です。

## 5. Lesson 4：Railsアプリを作る

ターミナルで実行します。`hello_rails`という同名フォルダが既にある場合は上書きせず、新しい名前を選んでください。

```bash
cd ~/projects/rails-learning
rails new hello_rails --database=sqlite3
cd hello_rails
bin/rails --version
bin/rails db:prepare
bin/rails server
```

`rails new`はアプリの雛形と必要なgemを用意します。初回は通信とインストールに時間がかかります。途中でエラーが出た場合はそのまま次へ進まず、最後のエラーを確認してください。

ブラウザで次を開きます。

```text
http://localhost:3000/
```

Railsの初期画面が見えれば成功です。**まだ自分のHello World画面ではありません。** サーバー用ターミナルはそのままにして、別のターミナルで編集します。サーバーを停止するときは、動かしているターミナルで`Ctrl+C`を押します。

### 今回見る場所

```text
hello_rails/
├── app/
│   ├── controllers/   # リクエストを受けて処理する
│   ├── models/        # データ・業務ルール。今回は追加しない
│   └── views/         # HTMLのテンプレート
├── config/routes.rb  # URLと処理の対応
├── Gemfile           # 必要なgemの指定
└── Gemfile.lock      # 解決された依存バージョン
```

アプリ作成後は、原則としてそのフォルダで`bin/rails`を使います。アプリが使うRailsを選択しやすくするためです。

今回はDBにデータを保存しません。SQLiteは雛形の標準的な開発用DBとして準備するだけで、Modelの作成は次のコースに回します。HTMLを返すだけでもRailsアプリは作れます。

公式資料：[Railsアプリの作成](https://guides.rubyonrails.org/getting_started.html#creating-a-new-rails-app)。

## 6. Lesson 5：Hello Worldを表示する

編集用ターミナルで、必ずアプリのフォルダに移動します。

```bash
cd ~/projects/rails-learning/hello_rails
```

今回は自動生成コマンドに任せず、小さな3ファイルを手でつなぎます。それぞれの役割が分かることを優先しています。

### Step 1：URLを処理につなぐ（Route）

```bash
nvim config/routes.rb
```

既存の`Rails.application.routes.draw do`と、その対応する最後の`end`の**間**に、次の行を追加します。既存のヘルスチェック等は消す必要がありません。

```ruby
root "greetings#index"
```

位置の例です。`...`は実際には入力しません。

```ruby
Rails.application.routes.draw do
  root "greetings#index"
  # 元からある他の設定は残します
end
```

`root`は`/`へのアクセスを扱います。`greetings#index`は、次に作る`GreetingsController`の`index`という処理を指します。

公式資料：[Rails Routing](https://guides.rubyonrails.org/routing.html)。

### Step 2：表示する値を用意する（Controller）

```bash
nvim app/controllers/greetings_controller.rb
```

ファイル全体を次の内容にします。

```ruby
class GreetingsController < ApplicationController
  def index
    @message = "Hello World!"
  end
end
```

`< ApplicationController`はクラスの継承です。`index`はアクションと呼ぶ、リクエストを処理するメソッドです。`@message`をテンプレートに渡します。

ファイル名は`greetings_controller.rb`、クラス名は`GreetingsController`です。Railsはこのような名前の対応を利用します。

公式資料：[Action Controller](https://guides.rubyonrails.org/action_controller_overview.html)。

### Step 3：HTMLを作る（View）

```bash
mkdir -p app/views/greetings
nvim app/views/greetings/index.html.erb
```

ファイル全体を次の内容にします。

```erb
<h1><%= @message %></h1>
<p>Neovimで作った最初のRailsページです。</p>
```

- `<h1>`：見出しです。
- `<p>`：段落です。
- `.html.erb`：HTMLの中にRubyを埋め込むテンプレートです。
- `<%= ... %>`：Rubyの式の結果をHTMLに出力します。
- `<% ... %>`：Rubyを実行しますが、その結果を直接出力しません。今回は使いません。

Railsは通常、このアクションに対応する`app/views/greetings/index.html.erb`を描画します。今回は明示的な`render`を書かなくても表示できます。

公式資料：[Action View](https://guides.rubyonrails.org/action_view_overview.html)。

### Step 4：ブラウザで確認する

すべてのファイルを保存してから、`http://localhost:3000/`を再読み込みします。サーバーを止めていた場合は、アプリのフォルダで再度`bin/rails server`を実行してください。

見出しの`Hello World!`と日本語の説明文が表示されれば、今回のゴール達成です。

確認用コマンドも実行してみます。

```bash
bin/rails routes -g root
curl -i http://localhost:3000/
```

確認ポイント：

- ルート一覧に`GET /`と`greetings#index`の対応があります。
- curlの応答はHTTPステータス`200`です。
- 応答HTML内に`<h1>Hello World!</h1>`があります。

## 7. Lesson 6：仕組みを確認し、自分で変更する

### リクエストの流れ

```text
ブラウザから GET /
  ↓
config/routes.rb
  root "greetings#index"
  ↓
GreetingsController#index
  @message に文字列を設定
  ↓
app/views/greetings/index.html.erb
  @message をHTMLへ埋め込む
  ↓
ブラウザへHTMLを返す
```

MVCは役割の分担です。

- **Model**：データや業務ルールを扱います。今回は不要です。
- **View**：表示を担当します。
- **Controller**：リクエストに応じて処理を行い、表示に必要な値を用意します。

### 課題A：表示を変える

Controllerの`"Hello World!"`を`"Hello Rails!"`に変更して保存し、ブラウザを再読み込みしてください。通常、開発モードではこの変更だけならサーバー再起動は不要です。

### 課題B：ViewとControllerを区別する

Viewの説明文だけを変更して、表示を確認してください。その後、次の質問に答えます。

1. URLとアクションを対応づけるファイルはどれですか。
2. 文字列を作っているのはどのファイルですか。
3. HTMLの見出しタグを書いたのはどのファイルですか。
4. `puts "Hello World!"`だけでは、なぜブラウザの本文にならないのでしょうか。

答え：1は`config/routes.rb`、2はController、3はViewです。4は`puts`が標準出力への出力であり、HTTPレスポンス本文の作成ではないためです。

最後はControllerを`"Hello World!"`に戻して保存します。次のテストを行う場合に表示文字列を揃えるためです。

## 8. 任意：自動テストを1本書く

ブラウザの確認だけでゴールは達成です。余裕があれば、同じ表示をコードで確認します。

```bash
mkdir -p test/integration
nvim test/integration/greeting_test.rb
```

```ruby
require "test_helper"

class GreetingTest < ActionDispatch::IntegrationTest
  test "root displays the greeting" do
    get root_url
    assert_response :success
    assert_select "h1", "Hello World!"
  end
end
```

```bash
bin/rails test test/integration/greeting_test.rb
```

失敗・エラーが0であることを確認します。このテストには実ブラウザの起動は不要です。表示を意図的に変えるとテストが失敗することも試し、その後元に戻してください。

公式資料：[Railsのテスト](https://guides.rubyonrails.org/testing.html)。

## 9. つまずいたときの確認表

| 症状 | 最初に確認すること |
| --- | --- |
| `ruby` / `rails` / `mise`が見つからない | 新しいターミナルを開く。miseの有効化、PATH、`which ruby`を確認します |
| Rubyが3.4系にならない | `cd ~/projects/rails-learning`後に`mise current`を確認します。複数のRuby管理ツールが競合していないか確認します |
| Railsが8.1系ではない | `gem list '^rails$'`で導入済みの正確な8.1系番号を確認し、`rails _8.1.x_ new hello_rails --database=sqlite3`の`8.1.x`をその実番号に置換して生成します。アプリ内では`bin/rails`を使います |
| gemの権限エラー | `sudo gem install`で回避せず、システムRubyを選んでいないか確認します |
| `rails new`でgemの導入に失敗 | エラーを確認します。フォルダとGemfileが生成済みならその中で`bundle install`を実行し、成功してから先に進みます |
| SQLiteのビルドで失敗 | macOSは`brew install sqlite3`、Ubuntuは`libsqlite3-dev`等の依存を確認します。エラー本文に示された不足を確認してから対処します |
| `bin/rails`がない | `pwd`と`ls`で`hello_rails`の中にいるか確認します |
| ポート3000を使用中 | 別のRailsが動いていないか確認します。必要なら`bin/rails server -p 3001`にし、URLも`http://localhost:3001/`へ変えます |
| 初期画面のまま | Routeの`root`追加、保存先、実行しているアプリのフォルダを確認します |
| `uninitialized constant GreetingsController` | ファイル名、クラス名、複数形`greetings`の綴りを確認します |
| `Missing template` | `app/views/greetings/index.html.erb`の綴りと階層を確認します |
| 見出しが空になる | Controllerの`@message`とViewの`@message`が一致するか、`<%=`になっているか確認します |
| 変更が反映されない | Neovimで`:w`したか、正しいURLを開いているか確認します。必要ならサーバーを再起動します |
| `Blocked hosts` | まず`localhost`を使います。この教材のためにホスト検証を無効化しないでください |
| Neovimの設定が原因か分からない | `nvim --clean ファイル名`でユーザー設定を読まずに編集し、切り分けます |

困ったときは、実行したコマンド・作業フォルダ・エラー全文・`ruby --version`・`bin/rails --version`を記録すると原因を絞れます。パスワードや秘密鍵などは共有しないでください。

## 10. 完了チェックと公式資料

- [ ] RubyとRailsの違いを説明できます。
- [ ] Neovimで作成・編集・保存・終了できます。
- [ ] Rubyの変数、メソッド、文字列の埋め込みを使えます。
- [ ] Railsを起動し、停止できます。
- [ ] `/`にアクセスすると、自分で作ったHello Worldが表示されます。
- [ ] Route → Controller → Viewの順番を説明できます。
- [ ] ControllerとViewを自分で変更できます。
- [ ] 任意：表示を検証するテストが成功しました。

### 翌日に10分で復習する

1. アプリのフォルダへ移動します。
2. サーバーを起動します。
3. 何も見ずに、今回編集した3ファイルの場所を思い出します。
4. 表示文言を変更して確認し、元に戻します。
5. サーバーを停止します。

ここまでで本コースは完了です。次はModel・マイグレーション・CRUDを使い、「メモを1件保存して表示する」アプリへ進むと自然です。LSPや補完プラグインは、その後に追加しても遅くありません。

### 公式資料一覧

- [Rails Installation](https://guides.rubyonrails.org/install_ruby_on_rails.html)
- [Rails Getting Started](https://guides.rubyonrails.org/getting_started.html)
- [Rails 8.1 Release Notes](https://guides.rubyonrails.org/8_1_release_notes.html)
- [Rails Routing](https://guides.rubyonrails.org/routing.html)
- [Action Controller Overview](https://guides.rubyonrails.org/action_controller_overview.html)
- [Action View Overview](https://guides.rubyonrails.org/action_view_overview.html)
- [Testing Rails Applications](https://guides.rubyonrails.org/testing.html)
- [Ruby in Twenty Minutes](https://www.ruby-lang.org/en/documentation/quickstart/)
- [Neovim：最初の操作](https://neovim.io/doc/user/usr_02/)
- [mise Getting Started](https://mise.jdx.dev/getting-started.html)
- [Homebrew](https://brew.sh/)

本教材の課題・コード例・学習順序は、このゴールに合わせて構成しています。参照先が将来更新される可能性があるため、別のRails系統を使う場合はそのバージョンの公式ガイドも確認してください。
