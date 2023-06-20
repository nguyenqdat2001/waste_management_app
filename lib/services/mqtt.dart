import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:quan_ly_rac_app/const.dart';

late MqttServerClient client;

Future<Stream<List<MqttReceivedMessage<MqttMessage>>>?> mqttSubscribe(
    {required String topic}) async {
  client = MqttServerClient(MQTT_HOST, MQTT_CLIENTID);
  client.port = MQTT_PORT;
  client.autoReconnect = true;

  try {
    await client.connect();
    if (client.connectionStatus?.state == MqttConnectionState.connected) {
      client.subscribe(topic, MqttQos.atLeastOnce);
      return client.updates;
    } else {
      return null;
    }
  } on NoConnectionException catch (e) {
    print(e.toString());
  }
}
