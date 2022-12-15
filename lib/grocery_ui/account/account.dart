import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Account extends StatelessWidget {
  const Account({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: Theme.of(context).brightness == Brightness.light ? SystemUiOverlayStyle.dark : SystemUiOverlayStyle.light,
      child: Scaffold(
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: ListTile(
                  title: Text('welcome, abdul hakeem', style: Theme.of(context).textTheme.headline6),
                  subtitle: Row(
                    children: [
                      Text('login to your account', style: Theme.of(context).textTheme.bodyText1),
                      SizedBox(width: 4),
                      Icon(CupertinoIcons.arrow_right, size: 14, color: Theme.of(context).disabledColor)
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(child: SizedBox(height: 10),),
              SliverToBoxAdapter(
                child: ListTile(
                  title: Text('my account', style: Theme.of(context).textTheme.subtitle1!.copyWith(
                    color: Theme.of(context).textTheme.caption!.color
                  )),
                ),
              ),
              SliverList(delegate: SliverChildListDelegate(List.generate(5, (index) => CustomWidget(index)).toList())),
              SliverToBoxAdapter(child: SizedBox(height: 10),),
              SliverToBoxAdapter(
                child: ListTile(
                  title: Text('my account', style: Theme.of(context).textTheme.subtitle1!.copyWith(
                      color: Theme.of(context).textTheme.caption!.color
                  )),
                ),
              ),
              SliverList(delegate: SliverChildListDelegate(List.generate(5, (index) => CustomWidget(index)).toList())),
              SliverToBoxAdapter(child: SizedBox(height: 10),),
              SliverToBoxAdapter(
                child: ListTile(
                  title: Text('my account', style: Theme.of(context).textTheme.subtitle1!.copyWith(
                      color: Theme.of(context).textTheme.caption!.color
                  )),
                ),
              ),
              SliverList(delegate: SliverChildListDelegate(List.generate(5, (index) => CustomWidget(index)).toList())),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomWidget extends StatelessWidget {
  CustomWidget(this._index, {Key? key}) : super(key: key) {}

  final int _index;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: () {

          },
          leading: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Theme.of(context).brightness == Brightness.light ? Colors.grey.shade200 : Colors.black,
              ),
              padding: EdgeInsets.all(8),
              child: Icon(CupertinoIcons.search)
          ),
          trailing: Icon(Icons.arrow_right),
          title: Text('Wishlist'),
        ),
        Divider(height: 0)
      ],
    );
  }
}
