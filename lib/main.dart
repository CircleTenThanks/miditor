import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // このウィジェットはアプリケーションのルートとなります
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'miditor',
      theme: ThemeData(
        // これはアプリケーションのテーマです
        //
        // お試し: "flutter run"でアプリケーションを実行してみてください。
        // アプリケーションのツールバーが紫色になっていることがわかります。
        // アプリを終了せずに、以下のcolorSchemeのseedColorをColors.greenに
        // 変更して「ホットリロード」を実行してみてください
        // （Flutter対応IDEで変更を保存するか「ホットリロード」ボタンを押すか、
        // コマンドラインから起動している場合は「r」を押してください）。
        //
        // カウンターがゼロにリセットされないことに注目してください。
        // アプリケーションの状態はリロード中も失われません。
        // 状態をリセットするには、ホットリスタートを使用してください。
        //
        // これは値だけでなくコードにも適用されます：
        // ほとんどのコード変更はホットリロードだけでテストできます。
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0x005ABDE3)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'miditor'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // このウィジェットはアプリケーションのホームページです。
  // これはStatefulです。つまり、見た目に影響を与えるフィールドを含む
  // Stateオブジェクト（以下で定義）を持っているということです。

  // このクラスは状態の設定を行います。親（この場合はAppウィジェット）から
  // 提供された値（この場合はタイトル）を保持し、Stateのbuildメソッドで
  // 使用されます。Widgetサブクラスのフィールドは常にfinalとして
  // マークされます。

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Map<String, dynamic>> _items = [];
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  int? _selectedIndex;
  Timer? _backspaceTimer;
  OverlayEntry? _overlayEntry;
  Offset? _buttonPosition;
  String? _currentKey;

  // アイテムの追加または更新を行うメソッド
  void _addOrUpdateItem(String text) {
    if (text.isEmpty) {
      _deleteSelectedItem();
    } else {
      setState(() {
        if (_selectedIndex != null) {
          _items[_selectedIndex!]['text'] = text;
        } else {
          _items.add({'text': text, 'isChecked': false});
        }
        _resetSelection();
      });
    }
  }

  // 選択中のアイテムを削除するメソッド
  void _deleteSelectedItem() {
    if (_selectedIndex != null) {
      setState(() {
        _items.removeAt(_selectedIndex!);
        _resetSelection();
      });
    }
  }

  // 選択状態をリセットするメソッド
  void _resetSelection() {
    _selectedIndex = null;
    _textController.clear();
    if (_focusNode.hasFocus) {
      _focusNode.requestFocus();
    }
  }

  // リストアイテムのウィジェットを生成するメソッド
  Widget _buildListItem(int index) {
    return ListTile(
      leading: Radio<int>(
        value: index,
        groupValue: _selectedIndex,
        onChanged: _onItemSelected(index),
      ),
      title: Text(_items[index]['text']),
      onTap: () => _onItemSelected(index)(index),
    );
  }

  // アイテム選択時の処理
  ValueChanged<int?> _onItemSelected(int index) {
    return (int? value) {
      setState(() {
        _selectedIndex = value;
        _textController.text = _items[index]['text'];
      });
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: _items.length,
                      itemBuilder: (context, index) => _buildListItem(index),
                    ),
                  ),
                  TextField(
                    controller: _textController,
                    focusNode: _focusNode,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: '入力してください...',
                    ),
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
          _buildCustomKeypad(), // カスタムキーパッドを追加
          _buildControlBar(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addOrUpdateItem(_textController.text),
        tooltip: 'TODO:ツールチップ',
        child: const Icon(Icons.add),
      ),
    );
  }

  // コントロールバーを生成するメソッド
  Widget _buildControlBar() {
    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
              icon: const Icon(Icons.play_arrow),
              onPressed: () {/* 再生処理 */},
            ),
            IconButton(
              icon: const Icon(Icons.pause),
              onPressed: () {/* 一時停止処理 */},
            ),
            IconButton(
              icon: const Icon(Icons.stop),
              onPressed: () {/* 停止処理 */},
            ),
          ],
        ),
      ),
    );
  }

  // カスタムキーパッドを生成するメソッド
  Widget _buildCustomKeypad() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: ['1', '2', '3', '⌫'].map((key) => _buildKeypadButton(key)).toList(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: ['4', '5', '6', '#'].map((key) => _buildKeypadButton(key)).toList(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _buildKeypadButton('7'),
              _buildKeypadButton('0'),
              const SizedBox(width: 60),
              _buildKeypadButton('♭'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildKeypadButton('_'),
              _buildKeypadButton('-'),
              _buildKeypadButton('¯'),
              const SizedBox(width: 60),
            ],
          ),
        ],
      ),
    );
  }

  // オーバーレイを表示
  void _showOverlay(BuildContext context, Offset position, String key) {
    _overlayEntry?.remove();
    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          Positioned(
            left: position.dx - 120,  // 横方向の位置
            top: position.dy - 40,    // 縦方向の位置
            child: Material(
              color: Colors.transparent,
              child: Container(
                width: 180,  // オーバーレイの幅
                height: 180, // オーバーレイの高さ
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(90),
                ),
                child: Stack(
                  children: [
                    // 上
                    Positioned(
                      top: 10,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Text(
                          '$key`',
                          style: const TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ),
                    // 下
                    Positioned(
                      bottom: 10,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Text(
                          '$key,',
                          style: const TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ),
                    // 左
                    Positioned(
                      left: 10,
                      top: 0,
                      bottom: 0,
                      child: Center(
                        child: Text(
                          '$key<',
                          style: const TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ),
                    // 右
                    Positioned(
                      right: 10,
                      top: 0,
                      bottom: 0,
                      child: Center(
                        child: Text(
                          '$key>',
                          style: const TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ),
                    // 中央
                    Center(
                      child: Text(
                        key,
                        style: const TextStyle(color: Colors.white, fontSize: 24),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  // オーバーレイを非表示にするメソッド
  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  Widget _buildKeypadButton(String key) {
  if (key == '⌫') {
    return SizedBox(
      width: 60,
      height: 60,
      child: GestureDetector(
        onLongPressStart: (_) {
          // ロングプレス開始時に定期的に文字を削除
          Timer.periodic(const Duration(milliseconds: 100), (timer) {
            if (_textController.text.isNotEmpty) {
              setState(() {
                _textController.text = _textController.text.substring(0, _textController.text.length - 1);
              });
            } else {
              timer.cancel();
            }
          });
        },
        onLongPressEnd: (_) {
          // ロングプレス終了時にタイマーをキャンセル
          _backspaceTimer?.cancel();
        },
        child: TextButton(
          onPressed: () {
            if (_textController.text.isNotEmpty) {
              setState(() {
                _textController.text = _textController.text.substring(0, _textController.text.length - 1);
              });
            }
          },
          child: const Text(
            '⌫',
            style: TextStyle(fontSize: 24),
          ),
        ),
      )
    );
  }
    
  // 数字キー（1-7）の場合はフリック入力に対応
  if (RegExp(r'^[1-7]$').hasMatch(key)) {
    return Builder(
      builder: (context) => SizedBox(
        width: 60,
        height: 60,
        child: GestureDetector(
          onTapDown: (details) {
            final RenderBox button = context.findRenderObject() as RenderBox;
            final Offset position = button.localToGlobal(details.localPosition);
            _showOverlay(
              context,
              Offset(
                position.dx + 30, // ボタンの中心に調整
                position.dy - 60  // オーバーレイがボタンの上に表示されるように調整
              ),
              key
            );
          },
          onTapUp: (_) {
            _hideOverlay();
            _textController.text = _textController.text + _currentKey!;
          },
          onPanUpdate: (details) {
            // フリック中の処理（必要に応じて）
          },
          onPanEnd: (details) async {
            _hideOverlay();
            if (await Vibration.hasVibrator() ?? false) {
              Vibration.vibrate(duration: 50);
            }
            
            if (details.velocity.pixelsPerSecond.dy.abs() > 
                details.velocity.pixelsPerSecond.dx.abs()) {
              // 垂直方向のフリック
              if (details.velocity.pixelsPerSecond.dy > 0) {
                _textController.text = '${_textController.text}$key,';
              } else {
                _textController.text = '${_textController.text}$key`';
              }
            } else {
              // 水平方向のフリック
              if (details.velocity.pixelsPerSecond.dx > 0) {
                _textController.text = '${_textController.text}$key>';
              } else {
                _textController.text = '${_textController.text}$key<';
              }
            }
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                key,
                style: const TextStyle(fontSize: 24),
              ),
            ),
          ),
        ),
      )
    );
  }
    
    return SizedBox(
      width: 60,
      height: 60,
      child: TextButton(
        onPressed: () async {
          if (await Vibration.hasVibrator() ?? false) {
            Vibration.vibrate(duration: 50);
          }
          _textController.text = _textController.text + key;
        },
        child: Text(
          key,
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _hideOverlay(); // オーバーレイを確実に削除
    _backspaceTimer?.cancel();
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}