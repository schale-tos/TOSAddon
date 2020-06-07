# JoyStick Plus

ジョイスティックのクイックスロットを拡張し、SET1とSET2を同時に表示、ボタンの割り当てを変更します。

![alt](https://raw.githubusercontent.com/schale-tos/TOSAddon/doc_images/joystickplus/images/joystickplus_quickslot.jpg "JoyStick Plus QuickSlot")

## 使い方
### (1) 「ゲーム設定」から設定

- 「UI設定＞ジョイスティック」の下あたりに「JoyStick+」という項目が追加されている
  - チェックを入れると有効化

![alt](https://raw.githubusercontent.com/schale-tos/TOSAddon/doc_images/joystickplus/images/joystickplus_settings.jpg "JoyStick Plus Settings")

### (2) 「コマンド」から設定

- チャットから以下のコマンドで設定。
  - onを指定すると有効化
```
/joystick+ [on/off]
```

## ボタンの割り当て

|割り当て|標準設定|JoyStick+|
|----|----|----|
|A|ジャンプ|（変更なし）|
|B|話す|（変更なし）|
|X|メイン武器攻撃|（変更なし）|
|Y|サブ武器攻撃／ガード|（変更なし）|
|L1+ABXY|クイックスロットの指定枠を実行|（変更なし）|
|L2+ABXY|クイックスロットの指定枠を実行|（変更なし）|
|L1+L2+上下右左|コンパニオン関連操作|-|
|L1+L2+ABXY|-|クイックスロットの指定枠を実行|
|L1+R2+ABXY|-|クイックスロットの指定枠を実行|
|R1+ABXY|クイックスロットの指定枠を実行|（変更なし）|
|R2+ABXY|クイックスロットの指定枠を実行|（変更なし）|
|R1+R2|座る|-|
|R1+R2+ABXY|-|クイックスロットの指定枠を実行|
|R1+L2+ABXY|-|クイックスロットの指定枠を実行|
|R1+R2+SELECT|-|座る|
|L2+R2|クイックスロットのSET1/SET2切り替え|-|
|L2+R2+(A,B,X,Y)|-|クイックスロットの指定枠を実行|
|SELECT|クエストワープ|コンパニオンに乗る|
|R1+SELECT|-|`/comeon`|
|R2+SELECT|-|コンパニオンから降りる|
|L1+SELECT|MAP表示|（変更なし）|
|L2+SELECT|-|クエストワープ|
|START|キャンセル|（変更なし）|
|L1+START|-|-|
|L2+START|クエストアイテム使用|（変更なし）|
|R1+START|UIモード|（変更なし）|
|R2+START|-|-|
|左スティックボタン|武器スワップ|（変更なし）|
|右スティックボタン|ターゲット固定|（変更なし）|

## 注意事項

- hotkey_joystick.xml は標準設定のままご利用ください。変更している場合、意図しない動作をする恐れがあります。

## 謝辞

- TP@黒猫亭様（tpJoyExt）、writ312様（joystickextender）を参考にさせて頂きました。
