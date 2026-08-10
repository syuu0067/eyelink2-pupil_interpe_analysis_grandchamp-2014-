 # Grandchamp(2014)の追試のためのRコード

 本コード群はpupil_grandchampのmatlabコードとセットでの運用を想定しています<br>
 `~/pupil/script`にあるスクリプトファイルから`~/pupil/data`にあるデータファイルを操作することを想定しています<br>

 ## 使い方
 `filtering.R`にてアーチファクト除去、補完、MW部分、RF部分の抜き出しを行います。出力形式はそれぞれ２ファイルで`被験者番号mw_dat.csv`と`被験者番号rf_dat.csv`の形(ex:`s101mw_dat.csv`)<br>
 その後、`interped-40per-low.R`で40%以上補完が行われているデータを削除します<br>
 `ignore less than 2second.R`は任意で使うコードです。`eject_num`で任意の数を指定することで指定した試行を削除できます。<br>
 `connect.R` を使用することで、同一被験者の複数データを統合できます<br>
 `analysis.R` にて分析を行います<br>

 ## 各ファイルの使い方
 `filtering.R` は`subject`の数値を指定することで動きます。`s101mw.edf`のような形を想定しており、`101`など被験者番号のみを指定してください<br>
 残りの各ファイルはsubjectに`s1`,`s2`などの形で入力してください<br>
 `interped-40per-low.R`と`ignore less than 2second.R`では上記の`subject`に加え、`data_num`にて`s103`の`3`など、データ番号を指定してください<br>

 ## `filtering.R` の中について
 データセットはeyelink2を使用して、`MW_REPORT`と`REFOCUS`というメッセージがそれぞれMW発生報告、再開というタイミングでデータセットに挿入されることを想定しています<br>
 もし、報告と再開の地点のメッセージ名を変更したい場合は`read.edf`の`start_marker`と`end_marker`を変更してください。startを再開時、endをMW報告時にするとよいです<br>
 後でどういった下処理をしているか書きます<br>

## 行われる処理
edfファイルから右目のみのデータを抜き取り、瞳孔径と眼球座標の値が０もしくはNAから前100ms、後300msの範囲を瞬目とし全てNAに変換した後、線形補完を行います。その際データセットの端が補完対象の場合は不完全なデータで補完されないよう、NAのままにしておくようになっています。<br>
瞳孔径の変化速度を計算し、pupil_velocity_average ＋－ SD*σの閾値に沿って線形補完を行います。σ＝1.5の定数<br>
最初に補完した瞬目範囲を差し戻します。



 # R Code for Replicating Grandchamp et al. (2014)

This set of R scripts is intended to be used together with the MATLAB code in `pupil_grandchamp`.<br>
The scripts are expected to be stored in `~/pupil/script` and used to process data files stored in `~/pupil/data`.<br>

## Usage

Use `filtering.R` to remove artifacts, interpolate missing or invalid data, and extract the mind-wandering (MW) and refocusing (RF) periods. Two output files are generated for each dataset using the following naming format: `participant_numbermw_dat.csv` and `participant_numberrf_dat.csv` (e.g., `s101mw_dat.csv`).<br>

Next, use `interped-40per-low.R` to remove epochs in which 40% or more of the data points have been interpolated.<br>

`ignore less than 2second.R` is an optional script. Specific trials can be excluded by assigning their trial numbers to `eject_num`.<br>

Use `connect.R` to combine multiple datasets from the same participant.<br>

Finally, use `analysis.R` to perform the statistical analyses.<br>

## Configuration of Each Script

`filtering.R` runs by specifying a numeric value for `subject`. The script assumes filenames such as `s101mw.edf`; therefore, enter only the participant number, such as `101`.<br>

For the remaining scripts, specify `subject` in a format such as ``s1`` or ``s2``.<br>

In `interped-40per-low.R` and `ignore less than 2second.R`, specify both `subject` and `data_num`. For example, for a dataset named `s103`, enter ``s1`` for `subject` and `3` for `data_num`.<br>

## Processing Performed in `filtering.R`

The dataset is assumed to have been recorded using an EyeLink 2 system. The messages `MW_REPORT` and `REFOCUS` are expected to be inserted into the dataset at the time of a mind-wandering report and at the time the participant resumes the task, respectively.<br>

To use different message names for the reporting and resumption points, change the `start_marker` and `end_marker` arguments in `read.edf`. It is recommended to assign the message recorded when the task is resumed to `start_marker` and the message recorded when mind wandering is reported to `end_marker`.<br>

A detailed description of the preprocessing procedures will be added later.<br>