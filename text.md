##vim-info
+viminfoでコンパイル時有効
書き込み・読み込み先はviminfofile
viminfofileがNONEの時は無効。
保存できる情報

- コマンドラインの履歴と検索履歴
- レジスタ
- マーク
- バッファリスト
- グローバル変数

vim終了時にこれらの情報がvim-infoに書き込まれ次にvimを実行するときに読み込まれる。

vimrcに設定を書き換えるべき

####vim-infoの設定を見直す
```{.vim :.vimrc}
"カンマ区切りで複数設定できる
:set viminfo=xxx

"マークの情報を保持するファイルの数を指定する
:set viminfo='num
"1000個のファイルのマーク情報を保存する
:set viminfo='1000

"グローバルマークとは
"(A-Z,0-9のマーク)
"グローバルマークを保存する
"default(無記入)で保存
:set viminfo='1000,f1
"保存しない
:set viminfo='1000,f0

"レジスタに保存できる行数を制限する
"500行まで
:set viminfo='1000,f0,<500

"s レジスタに保存するkbyte数を指定する。
"s10, 10kbyte以下のレジスタのみ保存する


""オプションほか
"コマンドライン履歴の数
":num 

"入力行履歴の数
"@num

"ファイルが編集されたときのエンコーディングから現在のエンコーディングに変換する
"c1

"記録する検索履歴の数
"/num

"r指定されたリムーバルメディア上のファイルを記録しない
"rA:,rB:
"一時ファイルなどを指定して保存しないようにするファイルを選択できる
"r/tmp,

"!名前が大文字から始まり、小文字を含まないグローバル変数を記録する(_などは使える
"!1でいいのかな

"h 'hisearch'の強調表示をしない

"defaultで復元しない
"% vimを引数なしで起動したときのみバッファリストを復元する

"変数viminfofileで上書きされる変数。保存先の名前
"nfile名
"n~/vim/viminfo
```

```
"viminfoに保存されているファイル名一覧
echo v:oldfiles
```

```
##viminfoのデフォルトの場所
#linux
$HOME/.viminfo

#windows
$HOME/_viminfo

$HOMEがなければ
$VIM/_viminfo
$VIMが指定されていなければ
C:_viminfo
```

```
#自分のviminfoを作って読み込む
rviminfo! ~/_my_viminfo


##[file]のでふぉるとはviminfo-file-name
#viminfo [file] ファイルを読み込む。
#!をつけるとすでに保存されている情報(レジスタ・マーク・oldfiles・その他)が上書きされる

#mviminfo [file]
古いファイルにマージされた後保存される。
!をつけると現在のinfoを正とする
```

```
それぞれ特色のあるviminfoを作ってautocmdなどで読み込むなどすれば
用途に応じたレジスタを組むことはできるね。
vimmerフォルダの使い道がまた一つ増えたといえる


```


```
#最近開いたファイルのリスト
browse oldfile
```


##参考
[aaa](https://vim-jp.org/vimdoc-ja/usr_21.html#21.3)
[aaa](https://vim-jp.org/vimdoc-ja/usr_21.html#21.3)
[aaa](https://vim-jp.org/vimdoc-ja/options.html#'viminfo')
[aaa](https://vim-jp.org/vimdoc-ja/starting.html#viminfo-file)


[aaa](https://vim-jp.org/vimdoc-ja/options.html#'viminfo')
[aaa](https://vim-jp.org/vimdoc-ja/starting.html#viminfo-file)


[aaa](https://noahorberg.hatenablog.com/entry/2019/12/15/144256)
[aaa](https://gorilla.netlify.app/articles/20190620-vim-session-plugin.html)
[aaa](https://kaworu.jpn.org/kaworu/2007-07-15-7.php)
[aaa](https://www.wazalab.com/2018/09/15/vim-session-%E3%83%97%E3%83%A9%E3%82%B0%E3%82%A4%E3%83%B3%E3%82%92%E4%BD%BF%E3%81%A3%E3%81%A6tab%E3%81%94%E3%81%A8session%E3%82%92%E4%BF%9D%E5%AD%98%E3%81%99%E3%82%8B%E6%96%B9%E6%B3%95/)
[aaa](https://keyamb.hatenablog.com/entry/2013/07/12/020730)
[aaa](https://github.com/skanehira/session.vim/tree/38c35f9796a5ebf28a98c95541287338bde6f618)
[aaa](https://note.com/noabou/n/naf81c6bf5a5b)
[aaa](https://qiita.com/gorilla0513/items/838138004f86b66d5668)
[aaa](https://qiita.com/gorilla0513/items/838138004f86b66d5668)


##vim-session
以前開いていたwindowが同じ場所。同じ大きさで戻せる。
マップやオプションの設定も復元される
保存される情報は`sessionoption`で設定できる
####セッションの作成
```
":mksession file名
:mksession xxx.vim
```

####セッションの復元
```
:source xxx.vim
```

####vimの起動と同時にセッションを再開する
```
vim -S xxx.vim
```

####設定を変更する
[](https://vim-jp.org/vimdoc-ja/options.html#'sessionoptions')
vimでmksessionが有効化されていること。
```
+mksession
```
設定すると復元を有効化する

- blank
    空のウィンドウ
- buffers
    ウィンドウに表示されたバッファ以外
    隠れバッファ。リストに載っているだけで読み込まれていないバッファ
- curdir
    カレントディレクトリ
- globals
    大文字で始まり最低一個の小文字を含む名前のグローバル変数。
    文字型と数値型のみ。
- help
    helpウィンドウ
- localoptions
    ウィンドウまたはばふぁに対してローカルなオプションとマッピング
- options
    すべてのオプション(local optionも含む)
- skiprtp
    オプションから`runtimepath`と`packpath`を取り除く
- resize
    vimのウィンドウのサイズ(lines/columns)の値
- sesdir
    セッションファイルが置かれているディレクトリがカレントディレクトリになる。
- slash
    ファイル内の`\`が`/`に変換される
- tabpage
    すべてのタブページ
    設定していなければカレントタブのみ復元。
    逆にタブページごとのセッションを保存できる
- terminal
    コマンドが復元できる。
    端末ウィンドウも含む。
- unix 
    windowsやDOSでも
- winpos
    ウィンドウ全体の位置
- winsize
    vimの全体のウィンドウのサイズ


```
"default
sessionoptions ="blank,buffers,curdir,folds,help,options,tabpages,winsize,terminal"
```














##vim-info
+viminfoでコンパイル時有効
書き込み・読み込み先はviminfofile
viminfofileがNONEの時は無効。
保存できる情報

- コマンドラインの履歴と検索履歴
- レジスタ
- マーク
- バッファリスト
- グローバル変数

vim終了時にこれらの情報がvim-infoに書き込まれ次にvimを実行するときに読み込まれる。

##infoに保存される情報は
main:
コマンドラインの履歴
    はほしいけれどこれはメインのviminfoで管理できる。

file::
マーク情報だけどこれはファイルごと。
    マークの情報はそれぞれのgitに保存してやりたいな。

global:
レジスタ(マクロも？)
    これはグローバルで管理したい。

highlight:
    マークのハイライトは必要

```
rviminfo! [file]
mviminfo [file]
```

##セッションに保存される情報は
windowのサイズや配置。開いているバッファ。




file:
- sesdir
    セッションファイルが置かれているディレクトリがカレントディレクトリになる。
- curdir
    カレントディレクトリ
- buffers
    ウィンドウに表示されたバッファ以外
    隠れバッファ。リストに載っているだけで読み込まれていないバッファ

global:
- winpos
    ウィンドウ全体の位置
- winsize
    vimの全体のウィンドウのサイズ
- resize
    vimのウィンドウのサイズ(lines/columns)の値
- blank
    空のウィンドウ








