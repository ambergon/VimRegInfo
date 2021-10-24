VimSelectInfo
=============
レジスタやviminfoを快適に活用するために制作されたプラグインです。

Usage:
------
詳細はdoc/VimSelectInfo.jaxを確認ください。

ウィンドウの表示
```
RegInfoWindow
```
ウィンドウの終了
```
RegInfoWindowOff
```
レジストリの入れ替え
```
RegExchange <1文字 or 2文字>
```
レジストリの清掃
```
RegInfoWindowClean
```

viminfoファイルの読み込み
```
SelectInfo
```
viminfoファイルの編集
```
SelectInfoEdit
```
viminfoファイルの書き込み
```
SelectInfoSave
```

ウィンドウが更新されるタイミング:
------
yank/delete等のコマンドの次に更新されます。
q/recordingによるレジストリの変更は拾われません。

License:
--------
MIT

Author:
-------
ambergon
[twitter](https://twitter.com/Sc_lFoxGon)
