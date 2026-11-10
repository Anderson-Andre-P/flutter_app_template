import 'package:flutter/material.dart';

import 'home_strings.dart';

/// The example screens the home grid links to. The router maps each one to
/// a route, so this feature never imports the examples feature.
enum HomeDemo {
  dashboard(
    Icons.space_dashboard_outlined,
    HomeStrings.dashboard,
    HomeStrings.dashboardHint,
  ),
  statement(
    Icons.receipt_long_outlined,
    HomeStrings.statement,
    HomeStrings.statementHint,
  ),
  detail(
    Icons.description_outlined,
    HomeStrings.detail,
    HomeStrings.detailHint,
  ),
  form(Icons.edit_note_outlined, HomeStrings.form, HomeStrings.formHint),
  success(
    Icons.check_circle_outline,
    HomeStrings.success,
    HomeStrings.successHint,
  ),
  feedback(
    Icons.chat_bubble_outline,
    HomeStrings.feedback,
    HomeStrings.feedbackHint,
  );

  const HomeDemo(this.icon, this.title, this.hint);

  final IconData icon;
  final String title;
  final String hint;
}
