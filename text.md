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
```


##参考
[](https://vim-jp.org/vimdoc-ja/options.html#'viminfo')
[](https://vim-jp.org/vimdoc-ja/starting.html#viminfo-file)





##vim-session










[](https://vim-jp.org/vimdoc-ja/usr_21.html#21.3)
