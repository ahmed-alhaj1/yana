import 'package:flutter/material.dart';
//import 'package:flutter/cupertino.dart';
import 'package:frontend2/sidebar.dart';
import 'package:ionicons/ionicons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppDrawer extends StatelessWidget {
  static const double _topMargin = 30;

  @override
  Widget build(BuildContext context) {
    String? currRoute = ModalRoute.of(context)!.settings.name;

    return Drawer(
      child: ListTileTheme(
          selectedColor: Theme.of(context).shadowColor,
          child: ListView(padding: EdgeInsets.zero, children: <Widget>[
            SizedBox(height: _topMargin),
            _DrawerObject(
              title: 'Friends',
              icon: Icons.people,
              selected: currRoute == SideBar.users_page,
              onTap: () => Navigator.pushNamed(context, SideBar.users_page),
            ),
            _DrawerObject(
                title: 'My Page',
                icon: Icons.feed,
                selected: currRoute == SideBar.feed,
                onTap: () => Navigator.pushNamed(context, SideBar.feed)),
            _DrawerObject(
              title: 'Edit Profile',
              icon: Icons.edit_attributes,
              selected: currRoute == SideBar.edProfile,
              onTap: () => Navigator.pushNamed(context, SideBar.edProfile),
            ),
            _DrawerObject(
              title: 'Profile',
              icon: FontAwesomeIcons.house,
              selected: currRoute == SideBar.profile,
              onTap: () => Navigator.pushNamed(context, SideBar.profile),
            ),
            _DrawerObject(
              title: 'match',
              icon: FontAwesomeIcons.peopleArrows,
              selected: currRoute == SideBar.match,
              onTap: () => Navigator.pushNamed(context, SideBar.match),
            ),
          ])),
    );
  }
}

class _DrawerObject extends StatelessWidget {
  static const double _iconSize = 30;
  final String _title;
  final bool _selected;
  final IconData _icon;
  //final IconData? _iicon;
  final VoidCallback _onTap;

  const _DrawerObject({
    @required title,
    icon = Icons.error,
    @required onTap,
    @required selected,
  })  : _title = title,
        _icon = icon,
        _onTap = onTap,
        _selected = selected;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      selected: _selected,
      leading: Icon(_icon, size: _iconSize),
      title: Text(_title,
          style: const TextStyle(color: Color.fromARGB(255, 90, 70, 11))),
      onTap: _onTap,
    );
  }
}
