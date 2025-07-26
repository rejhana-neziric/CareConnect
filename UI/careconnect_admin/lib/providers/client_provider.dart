import 'package:careconnect_admin/models/responses/client.dart';
import 'package:careconnect_admin/providers/base_provider.dart';

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
