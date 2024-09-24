import 'package:flutter/cupertino.dart';
import 'package:share_plus/share_plus.dart';

onShare(BuildContext context, String text, String link) async {
  final box = context.findRenderObject() as RenderBox?;
  await Share.share(link,
      sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
}
