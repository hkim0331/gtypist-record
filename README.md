#  Gtypist + record

## WHAT IS?

gnu-typist + 練習記録パッチ。

## 動作

練習ステージをひとつ終了したらその記録を ~/.gtypist に吐き出すよう、
gtypist を変更。

gtypist\_swing.rb あるいは gtypist\_tk.rb は定期的に ~/.gtypist を見て、
その更新状況をウィンドウ上に表示する。

gtypist.sh は記録を残すように改造した gtypist と共に viewer を立ち上げ、
gtypist の終了とともに viewer を終わらす。

## INSTALL on LINUX

情報センターPCへインストールの場合、

```sh
$ tar xfz gtypist-2.9.2.tar.gz
$ cd gtypist-2.9.2
$ ./configure --prefix=/edu
$ patch -p1 <../patch
$ make
$ make install
```

## INSTALL on OSX

```sh
$ tar xfz gtypist-2.9.2.tar.gz
$ cd gtypist-2.9.2
$ patch -p1 <../patch.osx
$ ./configure
$ patch -p1 <../patch
$ make
$ make install
```

## TODO

* (bug)swing ウィンドウが開いてもフォーカスを奪わないように。

* (bug)gtypist をインタラプトで終了すると、swing ウィンドウを取り残す。

* (solved 2013-04-02), インストールの方法のメモ。

* gtypist upload 機能。

* gtypist をスタート時に自動起動し、gtypist を終了したらビューアも消えるように。

* gtypist_tk.rb から記録をアップロードする。

* gtypist_tk.rb のムダループはなくせるか？

* (solved) osx でビルド出来ない。

    => Homebrew のパッチを入れる。(どんなパッチ？)

        Error:  both library and header files for the ncursesw library
        are required to build this package.  See INSTALL file for further
        information. On Debian/Ubuntu you need to install libncursesw5-dev.


  

---
programmed by Hiroshi Kimura, 2013-03-22.
