import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'content.dart';
import 'view_model.dart';

class SigninPage extends StatelessWidget {
  static const id = 'signin';
  SigninPage(this.nextPageId);
  final String nextPageId;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SigninViewModel()),
      ],
      builder: (context, child) {
        final _viewModel = Provider.of<SigninViewModel>(context, listen: false);
        _viewModel.setNextPageId(nextPageId);
        return child;
      },
      child: SigninPageContent(),
    );
  }
}
