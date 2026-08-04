// Web implementation: is this page already running as an installed app?
//
// Two checks because the platforms disagree. Android/Chrome sets the
// display-mode media query when launched from the Home Screen; iOS Safari
// does not, and exposes navigator.standalone instead. Checking only one would
// keep prompting exactly the users who already installed it.
import 'package:web/web.dart' as web;

bool isRunningStandalone() {
  try {
    if (web.window.matchMedia('(display-mode: standalone)').matches) return true;
    final nav = web.window.navigator as dynamic;
    return nav.standalone == true;
  } catch (_) {
    return false;
  }
}
