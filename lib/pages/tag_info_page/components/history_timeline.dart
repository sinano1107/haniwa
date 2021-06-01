import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timelines/timelines.dart';
import '../tag_info_view_model.dart';

class HistoryTimeline extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _viewModel = Provider.of<TagInfoViewModel>(context);
    final kTimeStyle = TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
    );

    return FixedTimeline.tileBuilder(
      theme: TimelineThemeData(
        nodePosition: 0.1,
        indicatorTheme: IndicatorThemeData(
          position: 0,
          size: 20.0,
        ),
        connectorTheme: ConnectorThemeData(
          thickness: 2.5,
        ),
      ),
      builder: TimelineTileBuilder.connected(
        itemCount: 2,
        contentsBuilder: (_, index) {
          return Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: (index == 0)
                  ? ([
                      Text(
                        '12:12',
                        style: kTimeStyle.copyWith(color: _viewModel.colors[0]),
                      ),
                      SizedBox(
                        height: 120,
                        child: Padding(
                          padding: EdgeInsets.all(15),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              DashedLineConnector(
                                color: Theme.of(context).primaryColor,
                              ),
                              SizedBox(width: 20),
                              Text(
                                '58分',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ])
                  : ([
                      Text(
                        '13:10',
                        style: kTimeStyle.copyWith(
                          color: _viewModel.colors[1],
                        ),
                      ),
                    ]),
            ),
          );
        },
        indicatorBuilder: (_, index) {
          return OutlinedDotIndicator(
            borderWidth: 2.5,
            color: (index != 1) ? _viewModel.colors[0] : _viewModel.colors[1],
            child: Icon(
              (index != 1) ? Icons.play_arrow : Icons.stop,
              color: (index != 1) ? _viewModel.colors[0] : _viewModel.colors[1],
              size: 15,
            ),
          );
        },
        connectorBuilder: (_, __, ___) => DecoratedLineConnector(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: _viewModel.colors,
            ),
          ),
        ),
      ),
    );
  }
}
