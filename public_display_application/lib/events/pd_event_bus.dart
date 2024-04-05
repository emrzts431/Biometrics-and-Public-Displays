import 'package:event_bus/event_bus.dart';

class PDEventBus extends EventBus {
  static final PDEventBus _instance = PDEventBus._();

  PDEventBus._();
  factory PDEventBus() {
    return _instance;
  }
}
