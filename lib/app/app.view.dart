part of 'app.main.dart';

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChangeTabCubit<int>(initialState: 0),
      child: BlocBuilder<ChangeTabCubit<int>, int>(
        builder: (context, selectedIndex) {
          final maxIndex = 1;
          final safeIndex = selectedIndex.clamp(0, maxIndex);
          return Scaffold(
            /* 
                IndexedStack is a widget in Flutter used to stack multiple widgets on top of each other 
              but only display one widget at a time based on the index.
                Other child widgets still exist in the widget tree, but are not displayed.
            */
            body: IndexedStack(
              index: safeIndex,
              children: [
                // Home Tab with its own Navigator

                /* 
                  Navigator is used to manage navigation between screens (routes/pages) in the application.

                  Route: Is a screen, usually a widget, that represents a page.
                */
                Navigator(
                  /* 
                    GlobalKey is a special key in Flutter that allows you to directly access a widget's State anywhere in the app.
                    When you use GlobalKey<NavigatorState>, you are creating a "window" to control the Navigator without context.

                    When to use -> When there is no BuildContext but still want to navigate
                  */
                  key: AppNavigatorService.homeNavigatorKey,
                  onGenerateRoute: (settings) {
                    return MaterialPageRoute(
                      builder: (_) => SCREENS[0],
                      settings: settings,
                    );
                  },
                ),
                // Profile Tab with its own Navigator
                Navigator(
                  key: AppNavigatorService.profileNavigatorKey,
                  onGenerateRoute: (settings) {
                    return MaterialPageRoute(
                      builder: (_) => SCREENS[1],
                      settings: settings,
                    );
                  },
                ),
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Trang chủ',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Cá nhân',
                ),
              ],
              currentIndex: selectedIndex,
              selectedItemColor: Colors.yellow,
              unselectedItemColor: Colors.grey,
              onTap:
                  (index) =>
                      context.read<ChangeTabCubit<int>>().changeTab(index),
            ),
          );
        },
      ),
    );
  }
}
