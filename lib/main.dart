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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
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
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // このsetStateの呼び出しは、Flutterフレームワークに対して
      // このStateで何かが変更されたことを通知します。これにより
      // 下のbuildメソッドが再実行され、表示が更新された値を
      // 反映するようになります。もしsetState()を呼び出さずに
      // _counterを変更した場合、buildメソッドは再度呼び出されず、
      // 何も変化が見られないことになります。
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // このメソッドは、上記の_incrementCounterメソッドなどで
    // setStateが呼び出されるたびに再実行されます。
    //
    // Flutterフレームワークは、buildメソッドの再実行を高速化
    // するように最適化されています。そのため、更新が必要な
    // 部分だけを再構築でき、ウィジェットのインスタンスを
    // 個別に変更する必要はありません。
    return Scaffold(
      appBar: AppBar(
        // お試し: ここの色を特定の色（たとえばColors.amber）に
        // 変更して、ホットリロードを実行してみてください。
        // AppBarの色が変わる一方で、他の色は同じままなことが
        // わかります。
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // ここでは、App.buildメソッドで作成されたMyHomePageオブジェクト
        // から値を取得し、それをアプリバーのタイトルとして使用します。
        title: Text(widget.title),
      ),
      body: Center(
        // Centerはレイアウトウィジェットです。単一の子要素を受け取り、
        // 親の中央に配置します。
        child: Column(
          // Columnもレイアウトウィジェットです。子要素のリストを受け取り、
          // それらを垂直に配置します。デフォルトでは、水平方向に子要素に
          // フィットするようにサイズを調整し、親と同じ高さになろうとします。
          //
          // Columnには、サイズ調整方法や子要素の配置方法を制御する
          // さまざまなプロパティがあります。ここではmainAxisAlignmentを
          // 使用して子要素を垂直方向に中央揃えにしています。
          // Columnは垂直なので、主軸は垂直軸です（交差軸は水平軸に
          // なります）。
          //
          // お試し: 「デバッグペイント」を有効にしてみてください
          // （IDEで「Toggle Debug Paint」アクションを選択するか、
          // コンソールで「p」を押してください）。各ウィジェットの
          // ワイヤーフレームが表示されます。
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // この末尾のカンマでbuildメソッドの自動フォーマットが見やすくなります。
    );
  }
}
