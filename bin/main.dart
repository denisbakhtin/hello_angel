import 'dart:async';
import 'package:angel_framework/angel_framework.dart';
import 'package:logging/logging.dart';
import 'package:angel_hot/angel_hot.dart';
import 'package:path/path.dart' as p;

main() async {
  //need to run main.dart with --observe flag
  var hot = new HotReloader(createServer, [
    p.join('bin', 'main.dart'),
  ]);
  print('Listening at http://127.0.0.1:3000');
  await hot.startServer('127.0.0.1', 3000);
}

Future<Angel> createServer() async {
  var app = new Angel();

  app.get('/', (req, res) => res.write("Angel says hello!"));

  app.fallback((req, res) => throw new AngelHttpException.notFound());

  app.logger = new Logger('angel')
    ..onRecord.listen((rec) {
      print(rec);
      if (rec.error != null) print(rec.error);
      if (rec.stackTrace != null) print(rec.stackTrace);
    });
  return app;
}
