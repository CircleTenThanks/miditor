import 'package:flutter/material.dart';

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
    _focusNode.requestFocus();
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
              _buildKeypadButton('b'),
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

  Widget _buildKeypadButton(String key) {
    return SizedBox(
      width: 60,
      height: 60,
      child: TextButton(
        onPressed: () {
          if (key == '⌫') {
            if (_textController.text.isNotEmpty) {
              _textController.text = _textController.text.substring(0, _textController.text.length - 1);
            }
          } else {
            _textController.text = _textController.text + key;
          }
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
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}