 # Grandchamp(2014)の追試のためのRコード

 本コード群はpupil_grandchampのmatlabコードとセットでの運用を想定しています  
 "~/pupil/script"にあるスクリプトファイルから"~/pupil/data"にあるデータファイルを操作することを想定しています  

 ## 使い方
 "filtering.R"にてアーチファクト除去、補完、MW部分、RF部分の抜き出しを行います。出力形式はそれぞれ２ファイルで"被験者番号mw_dat.csv"と"被験者番号rf_dat.csv"の形(ex:"s101mw_dat.csv")  
 その後、"interped-40per-low.R"で40%以上補完が行われているデータを削除します  
 "ignore less than 2second.R"は任意で使うコードです。"eject_num"で任意の数を指定することで指定した試行を削除できます。  
 "connect.R" を使用することで、同一被験者の複数データを統合できます  
 "analysis.R" にて分析を行います。  

 ## 各ファイルの使い方
 "filtering.R" は"subject"の数値を指定することで動きます。"s101mw.edf"のような形を想定しており、"101"など被験者番号のみを指定してください。  
 残りの各ファイルはsubjectに"s1","s2"などの形で入力してください  
 "interped-40per-low.R"と"ignore less than 2second.R"では上記の"subject"に加え、"data_num"にて"s103"の"3"など、データ番号を指定してください  

 ## "filtering.R" の中について
 データセットはeyelink2を使用して、"MW_REPORT"と"REFOCUS"というメッセージがそれぞれMW発生報告、再開というタイミングでデータセットに挿入されることを想定しています。  
 もし、報告と再開の地点のメッセージ名を変更したい場合は"read.edf"の"start_marker"と"end_marker"を変更してください。startを再開時、endをMW報告時にするとよいです。  
 後でどういった下処理をしているか書きます  