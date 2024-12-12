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
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: Radio<int>(
                            value: index,
                            groupValue: _selectedIndex,
                            onChanged: (int? value) {
                              setState(() {
                                _selectedIndex = value;
                                // 選択された場合、テキストフィールドにそのテキストを設定
                                _textController.text = _items[index]['text'];
                              });
                            },
                          ),
                          title: Text(_items[index]['text']),
                          onTap: () {
                            setState(() {
                              _selectedIndex = index; 
                              _textController.text = _items[index]['text']; 
                            });
                          },
                        );
                      },
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
                    onSubmitted: (text) {
                      setState(() {
                        if (text.isEmpty) {
                          // 空欄の場合、選択されたアイテムを削除
                          if (_selectedIndex != null) {
                            _items.removeAt(_selectedIndex!);
                            _selectedIndex = null; // 選択をリセット
                          }
                        } else {
                          // 新規アイテムを追加または更新
                          if (_selectedIndex != null) {
                            _items[_selectedIndex!]['text'] = text; // 更新
                          } else {
                            _items.add({'text': text, 'isChecked': false}); // 新規追加
                          }
                          _textController.clear(); // テキストフィールドをクリア
                        }
                        _selectedIndex = null; // ラジオボタンを未選択にする
                      });
                      _focusNode.requestFocus(); // フォーカスを維持
                    },
                  ),
                ],
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // 新規作成などの処理
        },
        tooltip: '新規作成',
        child: const Icon(Icons.add),
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