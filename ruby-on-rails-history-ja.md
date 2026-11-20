# RubyとRailsはなぜ生まれたのか

Rubyは、日常的な処理をスクリプトで自然に書けるようにするために作られたプログラミング言語です。Railsは、データベースを使うWebアプリを短期間で作るために、Rubyで書かれたフレームワークです。二つは、別々の開発者が異なる課題に取り組む中で、約10年の間隔を置いて生まれました。

## 1995年：Rubyが生まれた理由

まつもとゆきひろ（Matz）は、Perlのようなスクリプト言語の手軽さと、Smalltalkの一貫したオブジェクトモデルを兼ね備えた言語を作りたいと考えました。Rubyでは数値や文字列もオブジェクトとして扱い、処理のまとまりをブロックとしてメソッドに渡せます。

たとえば `names.map { |name| name.upcase }` では、ブロックに「それぞれの名前を大文字にする」と書くだけで、要素を順に処理する部分は `map` が担います。このような日常的な処理を自然に書けるようにすることが、Matzの狙いでした。Rubyは当初から汎用のプログラミング言語でした。[MatzによるRuby誕生の回顧](https://ruby-doc.org/docs/ruby-doc-bundle/ProgrammingRuby/book/foreword.html)、[Ruby公式サイト](https://www.ruby-lang.org/en/about/)

## 2004年：Railsが解決した問題

David Heinemeier Hansson（DHH）は、37signalsのプロジェクト管理アプリ「Basecamp」を開発していました。DHHは、実際に稼働していたBasecampから、ほかのWebアプリでも使える部分を取り出し、Railsとして公開しました。[Rails公開時の告知](https://signalvnoise.com/archives/000766)

当時のWebアプリ開発では、URLを処理に対応づけ、データベースの読み書きを行い、HTMLを描画し、それらを接続する作業がアプリごとに発生していました。Railsは、こうした処理を一つのフレームワークにまとめ、ファイル名やディレクトリ構成に共通の規約を設けました。規約に沿う部分は個別の設定を省けます。この方針を **「設定より規約」（Convention over Configuration）** と呼びます。[Railsの設計思想](https://rubyonrails.org/doctrine)

[Hello Worldコース](rails-neovim-hello-world-course.md)でも、この方針をすでに使っています。開発者は `root "greetings#index"` と書いて、`/` にアクセスしたときの処理を指定します。その処理を行う `GreetingsController#index` の実行後は、Railsが規約に従って `app/views/greetings/index.html.erb` を選びます。コントローラにテンプレートのパスを書く必要はありません。[Railsの描画ガイド](https://guides.rubyonrails.org/layouts_and_rendering.html)

データベースにも同じ考え方が使われます。たとえば `Post` モデルは、既定で `posts` テーブルに対応します。`Post.find(1)` と書けば、SQLを手書きせずに主キーが `1` のレコードを取得できます。設定が減る一方で、想定どおりに動かないときに調べるべき場所を知るには、規約を理解しておく必要があります。[Active Recordの基礎](https://guides.rubyonrails.org/active_record_basics.html)

## JavaやTypeScriptとの違い

| 技術 | 作られた目的 | Webアプリ開発での位置づけ |
| --- | --- | --- |
| Ruby on Rails | Webアプリに共通する処理を一つのフレームワークで提供する。 | ルーティング、コントローラ、ビュー、データベースアクセスをまとめて扱えます。土台となるRubyは動的型付けの言語です。 |
| Java | 静的に型を検査し、共通の実行環境を通じて異なるシステムで動くプログラムを書けるようにする。 | 初期の企業向けJava環境には、アプリの配置にXML設定ファイルを使うものがありました。これは当時の開発環境の特徴です。現在のSpring Bootでは、よく使う構成を自動で設定できます。[Javaの設計文書](https://www.oracle.com/java/technologies/language-environment.html)、[Java EEのXML設定仕様](https://www.jcp.org/xml/ns/javaee/)、[Spring Bootの公開告知](https://spring.io/blog/2014/04/01/spring-boot-1-0-ga-released/) |
| TypeScript | 型検査とエディタの支援で、大規模なJavaScriptアプリを保守しやすくする。 | 関数に誤った型の引数を渡すと、実行前に検出できます。アプリの構成はNext.jsやNestJSなどのフレームワークが提供します。TypeScriptの初公開はRailsの8年後、2012年でした。[MicrosoftによるTypeScriptの回顧](https://devblogs.microsoft.com/typescript/ten-years-of-typescript/) |

## RailsがWeb開発に与えた影響

2005年、DHHはデータベースを使う簡単なブログを約15分で作るデモを公開しました。ブログは当時すでに身近なアプリだったため、開発者は、いつも必要だった作業のうち何が省けるのかをその場で確かめられました。Basecampは、同じフレームワークで実際の製品を運用できる例でした。影響はRubyの外にも広がり、たとえば初期のPHPフレームワークSymfonyは、Railsのテンプレート用ヘルパーを取り入れました。注目されたのは、アイデアを動くアプリにするまでの時間を短縮できることでした。[当時のRailsデモ](https://www.youtube.com/watch?v=Gzj723LkRJY)、[Symfony公式ブログ](https://symfony.com/blog/open-source-cross-pollination)
