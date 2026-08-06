// =============================================================================
// lib/widgets/save_button.dart
//
// One save control, dropped onto anything saveable. Same account and same
// data as the web version, so something saved on a phone is there in a
// browser and the other way round.
//
// Signed out it is not disabled. A greyed-out icon teaches people the feature
// is broken; one that explains it needs an account teaches them why. Tapping
// while signed out says so and points at Account.
//
// Optimistic: the icon fills on tap and reverts if the request fails, because
// a control that waits on a round trip before responding feels broken on a
// ward connection.
// =============================================================================

import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/bookmarks_service.dart';

class SaveButton extends StatefulWidget {
  const SaveButton({
    super.key,
    required this.itemType,
    required this.itemId,
    this.size = 20,
  });

  final String itemType;
  final String itemId;
  final double size;

  @override
  State<SaveButton> createState() => _SaveButtonState();
}

class _SaveButtonState extends State<SaveButton> {
  bool _saved = false;
  bool _busy = false;

  String get _key => '${widget.itemType}:${widget.itemId}';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    if (AuthService.instance.accessToken == null) return;
    final ids = await BookmarksService.instance.savedIds();
    if (!mounted) return;
    setState(() => _saved = ids.contains(_key));
  }

  Future<void> _toggle() async {
    if (_busy) return;

    if (AuthService.instance.accessToken == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sign in to save — your saved items sync across devices.'),
        ),
      );
      return;
    }

    final previous = _saved;
    setState(() {
      _saved = !previous;
      _busy = true;
    });

    try {
      final now = await BookmarksService.instance
          .toggle(widget.itemType, widget.itemId);
      if (!mounted) return;
      setState(() {
        _saved = now;
        _busy = false;
      });
    } catch (e) {
      // Put it back and say why. A silent revert looks like a button that
      // does not work.
      if (!mounted) return;
      setState(() {
        _saved = previous;
        _busy = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e is NotSignedInException
              ? 'Sign in to save.'
              : e.toString().replaceFirst('Exception: ', '')),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colour = _saved
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).iconTheme.color?.withValues(alpha: 0.55);

    return IconButton(
      onPressed: _toggle,
      visualDensity: VisualDensity.compact,
      tooltip: _saved ? 'Remove from saved' : 'Save',
      icon: Icon(
        _saved ? Icons.bookmark : Icons.bookmark_border,
        size: widget.size,
        color: colour,
      ),
    );
  }
}
