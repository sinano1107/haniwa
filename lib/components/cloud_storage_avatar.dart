import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:haniwa/providers/cloud_storage_provider.dart';

class CloudStorageAvatar extends StatelessWidget {
  const CloudStorageAvatar({
    Key key,
    @required this.path,
    this.radius,
  }) : super(key: key);
  final String path;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _provider = Provider.of<CloudStorageProvider>(context);
    final _store = _provider.store;
    _provider.requestLoading(path);
    switch (_store[path]) {
      case 'loading':
        return CircleAvatar(
          child: CircularProgressIndicator(),
          backgroundColor: _theme.canvasColor,
          radius: radius,
        );
        break;
      case 'error':
        return CircleAvatar(
          child: Image.asset(
            'assets/images/error_haniwa.png',
            width: 25,
          ),
          backgroundColor: Colors.red,
          radius: radius,
        );
        break;
      default:
        return CircleAvatar(
          backgroundImage: NetworkImage(_store[path]),
          backgroundColor: _theme.canvasColor,
          radius: radius,
        );
    }
  }
}
