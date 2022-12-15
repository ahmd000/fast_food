import 'package:app/src/ui/categories/categories4.dart';
import 'package:flutter/material.dart';

class BlockTitle extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Function? onTapViewAll;
  const BlockTitle({Key? key, required this.title, this.subtitle, this.onTapViewAll})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headline6,
          ),
          onTapViewAll != null ? TextButton(
              style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size(60, 30),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  alignment: Alignment.centerLeft),
              onPressed: () => onTapViewAll!(), child: Text('View All')) : Container(),
        ],
      ),
      subtitle: subtitle != null ? Text(subtitle!, maxLines: 1, style: Theme.of(context).textTheme.bodyMedium) : null,
    );
  }
}
