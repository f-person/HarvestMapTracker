import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:harvest_tracker/place_action.dart';
import 'package:harvest_tracker/provider.dart';

Future<void> showNavigateOrEmailDialog(BuildContext context) async {
  final provider = Provider.of<HarvestTrackerProvider>(context, listen: false);
  final isDialogDisplayed = provider.isHarvestDialogDisplayed;
  if (isDialogDisplayed) return;

  provider.isHarvestDialogDisplayed = true;
  await showDialog<void>(
    context: context,
    builder: (context) => CupertinoAlertDialog(
      title: Text('Confirm'),
      content: Text('Please select Navigation or Send Email'),
      actions: [
        CupertinoDialogAction(
          child: Text('Navigate'),
          onPressed: () async {
            await PlaceAction.onNavigationAction();
          },
        ),
        CupertinoDialogAction(
          child: Text('Send Email'),
          onPressed: () async {
            await PlaceAction.onSendEmailAction();
          },
        )
      ],
    ),
  );
  provider.isHarvestDialogDisplayed = false;
}
