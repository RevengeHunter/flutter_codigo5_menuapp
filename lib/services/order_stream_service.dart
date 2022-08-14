import 'dart:async';

class OrderStreamService {
  static final OrderStreamService _instance = OrderStreamService._();

  OrderStreamService._();

  factory OrderStreamService() {
    return _instance;
  }

  int _counter = 0;

  StreamController<int> _counterStreamController = StreamController.broadcast();

  Stream<int> get counterStream => _counterStreamController.stream;

  int get counter => _counter;

  addCounter(){
    _counter++;
    _counterStreamController.add(_counter);
  }

  removeCounter(){
    _counter--;
    _counterStreamController.add(_counter);
  }

  closeStream(){
    _counterStreamController.close();
  }

}
