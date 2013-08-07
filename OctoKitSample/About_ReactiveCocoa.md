#ReactiveCocoaについて

どういうものかをざっと把握するために、GithubのREADMEの一部を訳してみた。
ちょっとまだどこまで理解できているのかわからないので、次はサンプルアプリものぞいてみる。

[参考：ReactiveCocoa](http://nshipster.com/reactivecocoa/)
[Github:ReactiveCocoa/ReactiveCocoa](https://github.com/ReactiveCocoa/ReactiveCocoa)

##Introduction

**ReactiveCocoa**はリアクティブ・プログラミングの機能が実装されています。

**RAC（ReactiveCocoa）**は現在と未来の値をキャプチャした`RACSignal`を提供します。

`RAC`はソフトウェア側が継続的に値の監視を行う必要はありません。

`RAC`は`RACSignal`に反応したり、連鎖させたり、結合させたりすることによって、宣言的に記述することができます。


`RACSignal`はFuture,Promiseデザインパターンのように、非同期処理を記述することができます。
これによってネットワークのコードを含むソフトウェアを大幅に簡素化することができます。

また`RAC`を使う主な利点の一つとしては、callbackやBlocks、notification、KVO、さらにdelegateメソッドといったあらゆる非同期処理を単一のインターフェイスで扱うことができる点といえるでしょう。

##Signals

次の例では、`self.username`に変更が合った場合、コンソールに新しい名前を表示させます。

`RACObserve(self, username)`によって現在の`self.username`の値を送信する`RACSignal`を新たに作成します。

`-subscribeNext: `：新しい値が送信されるたびにBlockが実行されます。


```
[RACObserve(self, username) subscribeNext:^(NSString *newName) {
    NSLog(@"%@", newName);
}];
```


##Chaining

`RACSignal`ははKVOのnotificationとは異なり連鎖することができます。

次の例では、コンソールに表示させるのは`"j"`から始まる名前の場合とします。

`-filter:`：そのBlock内の実行結果がYESを返したときにのみ値を送信する新しいRACSignalを返します。

```
[[RACObserve(self, username)
   filter:^(NSString *newName) {
       return [newName hasPrefix:@"j"];
   }]
   subscribeNext:^(NSString *newName) {
       NSLog(@"%@", newName);
   }];
```
##State

`Signal`は状態の導出にも用いることができます。

これまでのようにプロパティを監視し、その変化に応じて状態を示すための新たなプロパティを設定しなくとも、`RAC`によってSignalや操作そのものが状態の特性を示すことができるのです。

次の例では、パスワード入力欄とパスワード確認用の入力欄の値が同じであれば`createEnabled`を`True`とする一方向のバインディングを作成します。

`RAC()`はバインディングをいい感じに見せるためのマクロです。

`+combineLatest: reduce:`はSignalの配列を受け取り、各Signalの最新の値をもとにBlockを実行し、その実行結果に応じて新たに戻り値を送信する`RACSignal`を作成します。

```
RAC(self, createEnabled) = 
[RACSignal combineLatest:@[ RACObserve(self, password),RACObserve(self, passwordConfirmation)] 
				   reduce:^(NSString *password, NSString *passwordConfirm) {
        					return @([passwordConfirm isEqualToString:password]);
    }];
```

##Not just KVO

`Signal`はただ単にKVOするだけではなく、どんなストリーム上にでもつくりだすことができます。
次の例では、ボタンを押したかどうかについても表すことができます。

`RACCommand`はUIのアクションを示す`RACSignal`のサブクラスになります。

`-rac_command`がNSButtonに追加されています。
ボタンが押されることで自分自身にコマンドを通知します。

```
self.button.rac_command = [RACCommand command];
[self.button.rac_command subscribeNext:^(id _) {
    NSLog(@"button was pressed!");
}];
```


##Asynchronous network operations

次の例では、ネットワーク経由でログインするためのボタンをフックします。
ボタンが押される度に`loginCommand`が通知されます。


```
self.loginCommand = [RACCommand command];
```

`loginCommand`が値を送信するたびに、このBlockは、ログインプロセスを開始します。

`-addActionBlock:`コマンドが実行されるたびに、このブロック内で実行した結果を返します。

```
self.loginSignals = [self.loginCommand addActionBlock:^(id sender) {
　//この`-logIn`メソッドはrequestが完了したときにsignalを返します。
    return [client logIn];
}];
```

ログインが成功したときのみ、ログメッセージを表示します。

```
[self.loginSignals subscribeNext:^(RACSignal *loginSignal) {
    [loginSignal subscribeCompleted:^(id _) {
        NSLog(@"Logged in successfully!");
    }];
}];
```
ボタンをタップしたときにログインを実行するようにします。

```
self.loginButton.rac_command = self.loginCommand;
```



またSignalsはタイマーや他のUIイベント、時間を通じて変化するものについてであれば何でも表現することができます。

非同期の処理にSignalを使う場合、Signalを変換したり連鎖したりすることで、さらに複雑な処理を構築することができます。

次の例では２つのネットワーク処理の両方が完了した時点にコンソールログを表示する処理になります。

`+marge:`：Signalの配列を受け取り、全てのSignalが完了した時点で新しい`RACSignal`を返します。

`-subscribeCompleted:`：Signalが完了した時点でBlockを実行します。

```
[[RACSignal 
    merge:@[ [client fetchUserRepos], [client fetchOrgRepos] ]] 
    subscribeCompleted:^{
        NSLog(@"They're both done!");
    }];

```

SignalはBlockのコールバックをネスティングする代わりに非同期処理を順次実行するために連鎖させることができます。
これはFuture,Promiseデザインパターンでよく用いられる方法に似ています。

次の例では、まずユーザーログインを行い、キャッシュされたメッセージをロードします。次にサーバーから残りのメッセージを受信し、全てが終わった時点でコンソールにログを表示します。

`-flattenMap:`：新しいSignalを受ける度にBlockを実行し、受け取ったすべてのSignalを単一のSignalにマージして新しいRACSignalを返します。


```
[[[[client logInUser] //`-loginUser`は完了後にSignalを送る。 
    flattenMap:^(User *user) {
        // Return a signal that loads cached messages for the user.
        return [client loadCachedMessagesForUser:user];
    }]
    flattenMap:^(NSArray *messages) {
        // Return a signal that fetches any remaining messages.
        return [client fetchMessagesAfterMessage:messages.lastObject];
    }]
    subscribeNext:(NSArray *newMessages) {
        NSLog(@"New messages: %@", newMessages);
    } completed:^{
        NSLog(@"Fetched all messages.");
    }];
```


`RAC`は非同期処理の結果をバインドすることも容易になります。

次の例では、ユーザーの画像がダウンロードされたらすぐにself.imageViewのimageにセットするための一方向のバインディングをつくります。

`-deliverOn:`：他のキューに自分の仕事をさせる新しいSignalを作成します。この例ではメインスレッドに戻って、バックグラウンドキューに作業を移すために用いられています。

`-map:`：この例ではフェッチされたユーザーのBlockを呼び出し、Blockから返された値を送信する新しいRACSignalを返します。


```
RAC(self.imageView, image) = [[[[client 
    fetchUserWithUsername:@"joshaber"]
    deliverOn:[RACScheduler scheduler]]
    map:^(User *user) {
        // Download the avatar (this is done on a background queue).
        return [[NSImage alloc] initWithContentsOfURL:user.avatarURL];
    }]
    // Now the assignment will be done on the main thread.
    deliverOn:RACScheduler.mainThreadScheduler];

```
