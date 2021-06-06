import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:haniwa/common/snackbar.dart';
import 'components/wave.dart';
import 'components/google_signin_button.dart';
import 'signin_view_model.dart';

class SigninPage extends StatelessWidget {
  static const id = 'signin';
  final String nextPageId;
  SigninPage(this.nextPageId);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SigninViewModel()),
      ],
      child: SigninPageContent(nextPageId),
    );
  }
}

class SigninPageContent extends StatefulWidget {
  final String nextPageId;
  SigninPageContent(this.nextPageId);

  @override
  _SigninPageContentState createState() => _SigninPageContentState();
}

class _SigninPageContentState extends State<SigninPageContent> {
  @override
  void initState() {
    final viewModel = Provider.of<SigninViewModel>(context, listen: false);
    // グーグルサインインの結果
    viewModel.googleSigninAction.stream.listen((event) async {
      Navigator.pop(context);
      if (event.isSucceed) {
        print('成功しました');
        Navigator.pushReplacementNamed(context, widget.nextPageId);
      } else {
        showSnackBar(context, 'Googleサインインに失敗しました');
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // はにわくん
          Positioned(
            top: 80,
            right: 20,
            child: SvgPicture.asset(
              'assets/images/haniwa.svg',
              width: 180,
            ),
          ),
          // wave
          Wave(),
          // 画面
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: EdgeInsets.all(30),
                height: 550,
                decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                  borderRadius: BorderRadius.all(Radius.circular(40)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      spreadRadius: 1.0,
                      blurRadius: 10.0,
                      offset: Offset(0, -7),
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 10),
                    RichText(
                      text: TextSpan(
                        text: 'Haniwa',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                        children: [
                          TextSpan(
                            text: 'へようこそ',
                            style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodyText1.color,
                              fontSize: 30,
                            ),
                          ),
                          TextSpan(text: '👋'),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
                    Row(
                      children: [
                        Expanded(child: Divider(thickness: 2)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            'サインインしてください',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                        Expanded(child: Divider(thickness: 2)),
                      ],
                    ),
                    SizedBox(height: 70),
                    GoogleSigninButton(),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
