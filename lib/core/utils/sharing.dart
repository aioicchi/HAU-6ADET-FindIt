import 'package:flutter/foundation.dart';

import 'package:findit/core/utils/date_format.dart';
import 'package:findit/data/models/item.dart';

/// The deployed site. Links point here when the app isn't running in a browser.
const liveSiteUrl = 'https://aioicchi.github.io/HAU-6ADET-FindIt/';

/// A link that opens [item] directly, e.g. https://…/HAU-6ADET-FindIt/?item=4.
/// In the browser it uses the current address, so it also works on localhost.
Uri itemLink(Item item) {
  final base = kIsWeb ? Uri.base : Uri.parse(liveSiteUrl);
  return base.replace(queryParameters: {'item': item.id}).removeFragment();
}

/// The report as a message for a group chat. Contact info is left out on
/// purpose: people reach the reporter through FindIt.
String shareMessage(Item item, Uri link) {
  final when = isOlderThanAWeek(item.date) ? 'on ${fullDate(item.date)}' : timeAgo(item.date).toLowerCase();
  final description = item.description.trim();
  return [
    '${item.isLost ? 'LOST' : 'FOUND'} on campus: ${item.name}',
    'Where: ${item.fullLocation}',
    'When: ${item.isLost ? 'Lost' : 'Found'} $when',
    if (description.isNotEmpty) description,
    '',
    item.isLost
        ? 'Seen it? Message the owner on FindIt: $link'
        : 'Is it yours? Claim it on FindIt: $link',
  ].join('\n');
}

/// The `?item=` id the app was opened with, if any (web only).
String? linkedItemId() => kIsWeb ? Uri.base.queryParameters['item'] : null;
