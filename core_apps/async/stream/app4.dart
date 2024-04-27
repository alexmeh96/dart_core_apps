import 'dart:async';

// создаю стрим, чтобы использовать в примере
Stream<int> get sourceStream {
  final controller = StreamController<int>();
  Future<void>(() {
    controller
      ..add(1)
      ..add(2)
      ..addError(Exception('My error'))
      ..add(3)
      ..close();
  });

  return controller.stream;
}

/// Пример трансформации stream
void main() async {
  Stream<String> transformedStream = sourceStream.transform<String>(StreamTransformer.fromHandlers(
    handleData: (data, sink) {
      sink.add('* $data');
    },
    handleError: (error, _, sink) {
      // отправляем ошибку как данные
      sink.add(error.toString());
      // отправляем ошибку
      sink.addError(Exception('Your error'));
    }
  ));

  transformedStream.listen(
    (event) => print('DATA: $event'),
    onError: (error) => print('ERROR: $error'),
    // будет ли прерываться стрим, когда вернёт ошибку
    cancelOnError: false,
  );
}
