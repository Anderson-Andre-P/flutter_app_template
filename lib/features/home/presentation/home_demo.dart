import 'package:flutter/material.dart';

import 'home_strings.dart';

/// Section of the home grid a demo belongs to.
enum HomeDemoGroup { screens, components }

/// The example screens the home grid links to. The router maps each one to
/// a route, so this feature never imports the examples feature.
enum HomeDemo {
  dashboard(
    HomeDemoGroup.screens,
    Icons.space_dashboard_outlined,
    HomeStrings.dashboard,
    HomeStrings.dashboardHint,
  ),
  statement(
    HomeDemoGroup.screens,
    Icons.receipt_long_outlined,
    HomeStrings.statement,
    HomeStrings.statementHint,
  ),
  detail(
    HomeDemoGroup.screens,
    Icons.description_outlined,
    HomeStrings.detail,
    HomeStrings.detailHint,
  ),
  form(
    HomeDemoGroup.screens,
    Icons.edit_note_outlined,
    HomeStrings.form,
    HomeStrings.formHint,
  ),
  success(
    HomeDemoGroup.screens,
    Icons.check_circle_outline,
    HomeStrings.success,
    HomeStrings.successHint,
  ),
  states(
    HomeDemoGroup.screens,
    Icons.hourglass_empty,
    HomeStrings.states,
    HomeStrings.statesHint,
  ),
  widgets(
    HomeDemoGroup.components,
    Icons.widgets_outlined,
    HomeStrings.widgets,
    HomeStrings.widgetsHint,
  ),
  bottomNav(
    HomeDemoGroup.components,
    Icons.call_to_action_outlined,
    HomeStrings.bottomNav,
    HomeStrings.bottomNavHint,
  ),
  modals(
    HomeDemoGroup.components,
    Icons.web_asset_outlined,
    HomeStrings.modals,
    HomeStrings.modalsHint,
  ),
  sheets(
    HomeDemoGroup.components,
    Icons.vertical_align_bottom,
    HomeStrings.sheets,
    HomeStrings.sheetsHint,
  ),
  toasts(
    HomeDemoGroup.components,
    Icons.notifications_none,
    HomeStrings.toasts,
    HomeStrings.toastsHint,
  ),
  forms(
    HomeDemoGroup.components,
    Icons.edit_calendar_outlined,
    HomeStrings.forms,
    HomeStrings.formsHint,
  ),
  navigation(
    HomeDemoGroup.components,
    Icons.tab_outlined,
    HomeStrings.navigation,
    HomeStrings.navigationHint,
  ),
  chat(
    HomeDemoGroup.components,
    Icons.forum_outlined,
    HomeStrings.chat,
    HomeStrings.chatHint,
  ),
  controls(
    HomeDemoGroup.components,
    Icons.toggle_on_outlined,
    HomeStrings.controls,
    HomeStrings.controlsHint,
  ),
  charts(
    HomeDemoGroup.components,
    Icons.insert_chart_outlined,
    HomeStrings.charts,
    HomeStrings.chartsHint,
  );

  const HomeDemo(this.group, this.icon, this.title, this.hint);

  final HomeDemoGroup group;
  final IconData icon;
  final String title;
  final String hint;
}
