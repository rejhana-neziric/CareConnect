import 'package:careconnect_mobile/models/responses/client.dart';
import 'package:careconnect_mobile/providers/base_provider.dart';

class ClientProvider extends BaseProvider<Client> {
  ClientProvider() : super("Client");

  @override
  Client fromJson(data) {
    return Client.fromJson(data);
  }

  @override
  int? getId(Client item) {
    return item.user?.userId;
  }
}
