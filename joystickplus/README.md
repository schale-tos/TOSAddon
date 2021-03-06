# JoyStick Plus

ジョイスティックのクイックスロットを拡張し、SET1とSET2を同時に表示、ボタンの割り当てを変更します。

![alt](https://raw.githubusercontent.com/schale-tos/TOSAddon/doc_images/joystickplus/images/joystickplus_quickslot.jpg "JoyStick Plus QuickSlot")

## 使い方
### (1) 「ゲーム設定」から設定

- 「ゲーム設定」に「JoyStick+」という項目が追加されている
  - チェックを入れると有効化
  - 有効／無効は全てのキャラクターで共通です

![alt](https://raw.githubusercontent.com/schale-tos/TOSAddon/doc_images/joystickplus/images/joystickplus_settings.jpg "JoyStick Plus Settings")

### (2) 「コマンド」から設定

- チャットから以下のコマンドで設定。
  - onを指定すると有効化
  - 有効／無効は全てのキャラクターで共通です
  
```
/joystick+ [on/off]
```

## ボタンの割り当て

### ボタンのアクション割り当ての変更

- SELECTとL1/L2/R1/R2の組み合わせは割り当てるアクションを変更することが可能です
  - JoyStick+を有効にした状態で「UI設定＞キーの設定」を開くとジョイスティック用の設定項目が追加されています
  - ボタンに対してアクションを設定してください　（重複可能）
  - ここで設定したボタンのアクション割り当ては全てのキャラクターで共通です

![alt](https://raw.githubusercontent.com/schale-tos/TOSAddon/doc_images/joystickplus/images/joystickplus_keyconfig.jpg "JoyStick Plus KeyConfig")

### 基本機能
|割り当て|標準設定|JoyStick+|変更可否|
|----|----|----|----|
|A|ジャンプ|ジャンプ|×|
|B|話す|話す|×|
|X|メイン武器攻撃|メイン武器攻撃|×|
|Y|サブ武器攻撃／ガード|サブ武器攻撃／ガード|×|

### クイックスロット操作
|割り当て|標準設定|JoyStick+|変更可否|
|----|----|----|----|
|L1+ABXY|クイックスロットの指定枠を実行|クイックスロットの指定枠を実行|×|
|L2+ABXY|クイックスロットの指定枠を実行|クイックスロットの指定枠を実行|×|
|R1+ABXY|クイックスロットの指定枠を実行|クイックスロットの指定枠を実行|×|
|R2+ABXY|クイックスロットの指定枠を実行|クイックスロットの指定枠を実行|×|
|L1+R1+ABXY|クイックスロットの指定枠を実行|クイックスロットの指定枠を実行|×|
|L2+R2+ABXY|-|クイックスロットの指定枠を実行|×|
|L1+L2+ABXY|-|クイックスロットの指定枠を実行|×|
|L1+R2+ABXY|-|クイックスロットの指定枠を実行|×|
|R1+R2+ABXY|-|クイックスロットの指定枠を実行|×|
|R1+L2+ABXY|-|クイックスロットの指定枠を実行|×|

### その他操作　（変更可／デフォルト設定）
|割り当て|標準設定|JoyStick+（デフォルト設定）|変更可否|
|----|----|----|----|
|SELECT|クエストワープ|コンパニオンに乗る|○|
|L1+SELECT|MAP表示|MAP表示|○|
|L2+SELECT|-|クエストワープ|○|
|R1+SELECT|-|チャットマクロ 1|○|
|R2+SELECT|-|コンパニオンから降りる|○|
|L1+L2+SELECT|-|-|○|
|L1+R1+SELECT|-|-|○|
|L1+R2+SELECT|-|-|○|
|R1+R2+SELECT|-|座る|○|
|L2+R2+SELECT|-|-|○|
|R1+L2+SELECT|-|-|○|
|L1+L2+R1+SELECT|-|-|○|
|L1+L2+R2+SELECT|-|-|○|
|L1+R1+R2+SELECT|-|-|○|
|L2+R1+R2+SELECT|-|-|○|
|L1+L2+R1+R2+SELECT|-|-|○|

### その他操作　（変更不可）
|割り当て|標準設定|JoyStick+|変更可否|
|----|----|----|----|
|START|ESCキー|ESCキー|×|
|L1+START|-|-|×|
|L2+START|クエストアイテム使用|クエストアイテム使用|×|
|R1+START|UIモード|UIモード|×|
|R2+START|-|-|×|
|左スティックボタン|武器スワップ|武器スワップ|×|
|右スティックボタン|ターゲット固定|ターゲット固定|×|

### 無効化されるもの
|割り当て|標準設定|JoyStick+|変更可否|
|----|----|----|----|
|L1+L2+上下右左|コンパニオン関連操作|-|
|R1+R2|座る|-|
|L2+R2|クイックスロットのSET1/SET2切り替え|-|

## 注意事項

- このアドオンは release/hotkey_joystick_user.xml を上書きしますのでご注意ください。

## 謝辞

- TP@黒猫亭様（tpJoyExt）、writ312様（joystickextender）を参考にさせて頂きました。
