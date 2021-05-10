import 'package:market_categories_bloc/src/models/models.dart';
import 'package:market_categories_bloc/src/mqtt/MQTTAppState.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MQTTManager {
  //Instancias do cliente
  MQTTAppState _currentState;
  MqttServerClient _client;

  String _id;
  String _host;

  final Function _onMessageCallback;

  //Constructor
  MQTTManager(
      this._host, this._id, this._currentState, this._onMessageCallback);

  void initMQTTClient() {
    _client = MqttServerClient(_host, _id);
    _client.port = 80; //1883;
    _client.keepAlivePeriod = 20;
    _client.logging(on: false);
    //hadlers
    _client.onDisconnected = onDisconnected;
    _client.onConnected = onConnected;
    _client.onSubscribed = onSubscribed;

    final connMess = MqttConnectMessage()
        .withClientIdentifier(_id)
        .withWillTopic('willTopic')
        .withWillMessage('willMessage')
        .startClean();
    print("[MQTT] Mosquito client connecting ...");
  }

  Future<void> connect() async {
    assert(_client != null);
    try {
      print("[MQTT] Client connecting ...");
      _currentState.setAppConnectionState(MQTTAppConnectionState.connecting);
      await _client.connect();
      _client.updates.listen((List<MqttReceivedMessage<MqttMessage>> c) {
        final MqttPublishMessage message = c[0].payload;
        final payload =
            MqttPublishPayload.bytesToStringAsString(message.payload.message);
        _currentState.setReceivedText(payload);
        print('Received message:$payload from topic: ${c[0].topic}>');
        _onMessageCallback(c[0].topic, payload);
      });
    } on Exception catch (e) {
      print("[MQTT] Client error => $e");
      disconnect();
    }
  }

  MQTTAppState getCurrentState() {
    return _currentState;
  }

  void disconnect() {
    print("[MQTT] Disconnect ...");
    _client.disconnect();
  }

  void subscribe(String topic) {
    _client.subscribe(topic, MqttQos.atLeastOnce);
  }

  void unsubscribe(String listId) {
    _client.unsubscribe(listId);
  }

  void publish(String topic, String message_payload) {
    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    //builder.addString(list.getProductsIds().toString());
    builder.addString(message_payload);
    _client.publishMessage(topic, MqttQos.exactlyOnce, builder.payload,
        retain: true);
  }

  void publishNoRetain(String topic, String message_payload) {
    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    //builder.addString(list.getProductsIds().toString());
    builder.addString(message_payload);
    _client.publishMessage(topic, MqttQos.exactlyOnce, builder.payload,
        retain: false);
  }

  //handlers
  void onSubscribed(String topic) {
    print("[MQTT] Client subcribed to $topic");
  }

  void onDisconnected() {
    print("[MQTT] Client disconnection ...");
    _currentState.setAppConnectionState(MQTTAppConnectionState.disconnected);
  }

  void onConnected() {
    _currentState.setAppConnectionState(MQTTAppConnectionState.connected);
    print("[MQTT] Client connected ...");
  }
}
