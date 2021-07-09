import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:haniwa/providers/cloud_storage_provider.dart';

class CloudStorageImage extends StatelessWidget {
  const CloudStorageImage({
    Key key,
    @required this.path,
  }) : super(key: key);
  final String path;

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<CloudStorageProvider>(context, listen: false);
    final _store = _provider.store;
    _provider.requestLoading(path);
    switch (_store[path]) {
      case 'loading':
        return CircularProgressIndicator();
        break;
      case 'error':
        return Text('エラー');
        break;
      default:
        return Image.network(_store[path]);
    }
  }
}
