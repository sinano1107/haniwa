import 'package:flutter/material.dart';

class ListPage extends StatelessWidget {
  static const id = 'list';
  final List<Quest> questList = [
    Quest(
      name: 'お皿洗い',
      minutes: 10,
      point: 50,
      subscriber: 'まさき',
    ),
    Quest(
      name: 'お皿洗い',
      minutes: 10,
      point: 50,
    ),
    Quest(
      name: '片付け',
      minutes: 15,
      point: 500,
    ),
    Quest(
      name: 'お皿洗い',
      minutes: 10,
      point: 50,
      subscriber: 'まさき',
    ),
    Quest(
      name: 'お皿洗い',
      minutes: 10,
      point: 50,
    ),
    Quest(
      name: '片付け',
      minutes: 15,
      point: 500,
    ),
    Quest(
      name: 'お皿洗い',
      minutes: 10,
      point: 50,
      subscriber: 'まさき',
    ),
    Quest(
      name: 'お皿洗い',
      minutes: 10,
      point: 50,
    ),
    Quest(
      name: '片付け',
      minutes: 15,
      point: 500,
    ),
    Quest(
      name: 'お皿洗い',
      minutes: 10,
      point: 50,
      subscriber: 'まさき',
    ),
    Quest(
      name: 'お皿洗い',
      minutes: 10,
      point: 50,
    ),
    Quest(
      name: '片付け',
      minutes: 15,
      point: 500,
    ),
    Quest(
      name: 'お皿洗い',
      minutes: 10,
      point: 50,
      subscriber: 'まさき',
    ),
    Quest(
      name: 'お皿洗い',
      minutes: 10,
      point: 50,
    ),
    Quest(
      name: '片付け',
      minutes: 15,
      point: 500,
    ),
    Quest(
      name: 'お皿洗い',
      minutes: 10,
      point: 50,
      subscriber: 'まさき',
    ),
    Quest(
      name: 'お皿洗い',
      minutes: 10,
      point: 50,
    ),
    Quest(
      name: '片付け',
      minutes: 15,
      point: 500,
    ),
    Quest(
      name: 'お皿洗い',
      minutes: 10,
      point: 50,
      subscriber: 'まさき',
    ),
    Quest(
      name: 'お皿洗い',
      minutes: 10,
      point: 50,
    ),
    Quest(
      name: '片付け',
      minutes: 15,
      point: 500,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            leading: Icon(Icons.menu),
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsets.only(bottom: 10),
              title: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('おすすめのクエスト'),
                  SizedBox(height: 10),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    child: Material(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: _theme.canvasColor,
                      child: InkWell(
                        child: _menuItem(
                          context,
                          Quest(name: 'aaa', minutes: 10, point: 1000),
                          showBorder: false,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              background: Container(
                color: _theme.accentColor,
              ),
            ),
            pinned: true,
            collapsedHeight: MediaQuery.of(context).size.height * 0.13,
            expandedHeight: MediaQuery.of(context).size.height * 0.23,
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              questList.map((q) => _menuItem(context, q)).toList() +
                  [
                    Container(height: 30),
                  ],
            ),
          ),
          SliverList(delegate: SliverChildListDelegate([Container()]))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: _theme.primaryColor,
        onPressed: () {},
      ),
    );
  }
}

Widget _menuItem(BuildContext context, Quest q, {bool showBorder = true}) {
  final _theme = Theme.of(context);

  return Container(
    decoration: BoxDecoration(
      // color: _theme.canvasColor,
      border: showBorder
          ? Border(
              bottom: BorderSide(
                width: 1.0,
                color: Colors.grey[300],
              ),
            )
          : null,
    ),
    child: InkWell(
      hoverColor: _theme.canvasColor,
      child: ListTile(
        leading: SizedBox(
          height: 35,
          child: CircleAvatar(
            backgroundColor: Colors.blue,
          ),
        ),
        title: Text(
          q.name,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: q.subscriber != null
            ? Text(
                '${q.subscriber}が予約済み',
                style: TextStyle(
                    color: _theme.accentColor, fontWeight: FontWeight.bold),
              )
            : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${q.minutes}分',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            SizedBox(width: 10),
            Text(
              '${q.point}pt',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        onTap: () => print('aaa'),
      ),
    ),
  );
}

class Quest {
  Quest({
    @required this.name,
    @required this.minutes,
    @required this.point,
    this.subscriber,
  });
  final String name;
  final int minutes;
  final int point;
  final String subscriber;
}
