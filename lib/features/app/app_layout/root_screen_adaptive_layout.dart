import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../app_router/app_router.gr.dart';
import 'root_screen_helper.dart';
import 'active_tab_notifier.dart';

@RoutePage(name: 'RootAdaptiveScreenRoute')
class RootAdaptiveScreen extends ConsumerStatefulWidget {
  /// Creates a const [RootAdaptiveScreen].
  const RootAdaptiveScreen({super.key, this.transitionDuration = 1000});

  /// Declare transition duration.
  final int transitionDuration;

  @override
  ConsumerState<RootAdaptiveScreen> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<RootAdaptiveScreen> {
  // int selectedNavigation = 0;
  int _transitionDuration = 1000;

  Future<void> onSelectedIndexChange(int index) async {
    ref.read(activeTabIndexProvider.notifier).updateActiveTabIndex(index);
  }

  // Define the children to display within the body.
  final List<Widget> fakeChildren = List<Widget>.generate(10, (int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        color: const Color.fromARGB(255, 255, 201, 197),
        height: 40,
      ),
    );
  });
  // Initialize transition time variable.

  // Define the list of destinations to be used within the app.
  List<NavigationDestination> destinations = RootHelper.destinations;

  @override
  void initState() {
    super.initState();
    setState(() {
      _transitionDuration = widget.transitionDuration;
    });
  }

  final TextStyle headerColor = const TextStyle(
    color: Color.fromARGB(255, 255, 201, 197),
  );

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final NavigationRailThemeData navRailTheme =
        Theme.of(context).navigationRailTheme;

    final Widget trailingNavRail = Column(
      children: <Widget>[
        Divider(color: colorScheme.outline),
        const SizedBox(height: 10),
        Row(
          children: <Widget>[
            const SizedBox(width: 27),
            Text(
              'Settings',
              style: TextStyle(fontSize: 16, color: colorScheme.onSurface),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: <Widget>[
            const SizedBox(width: 16),
            IconButton(
              onPressed: () {
                context.router.push(ThemeSettingsRoute());
              },
              icon: Icon(
                Icons.folder_copy_outlined,
                color: colorScheme.primary,
              ),
              iconSize: 21,
            ),
            const SizedBox(width: 21),
            Flexible(
              child: Text(
                'Freelance',
                style: TextStyle(color: colorScheme.onSurface),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
      ],
    );

    // Wrap the AdaptiveLayout in a AutoTabsRouter to enable navigation between tabs.
    return AutoTabsRouter(
      routes: RootHelper.routes,
      builder: (context, child) {
        final tabsRouter = AutoTabsRouter.of(context);

        final activeTabIndex =
            ref.watch(activeTabIndexProvider).valueOrNull ?? 0;
        // Synchronize tabsRouter's activeIndex with the selectedTabProvider after the build phase
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (tabsRouter.activeIndex != activeTabIndex) {
            tabsRouter.setActiveIndex(activeTabIndex);
          }
        });

        return AdaptiveLayout(
          // An option to override the default transition duration.
          transitionDuration: Duration(milliseconds: _transitionDuration),
          // Primary navigation config has nothing from 0 to 600 dp screen width,
          // then an unextended NavigationRail with no labels and just icons then an
          // extended NavigationRail with both icons and labels.
          // medium vs mediumLarger = extended: false vs true ,
          primaryNavigation: SlotLayout(
            config: <Breakpoint, SlotLayoutConfig>{
              Breakpoints.medium: SlotLayout.from(
                inAnimation: AdaptiveScaffold.leftOutIn,
                key: const Key('Primary Navigation Medium'),
                builder:
                    (_) => AdaptiveScaffold.standardNavigationRail(
                      selectedIndex: tabsRouter.activeIndex,
                      onDestinationSelected: (int newIndex) {
                        setState(() {
                          onSelectedIndexChange(newIndex);
                          tabsRouter.setActiveIndex(newIndex);
                        });
                      },
                      extended: false,
                      leading: const Icon(Icons.menu),
                      destinations:
                          destinations
                              .map(
                                (NavigationDestination destination) =>
                                    AdaptiveScaffold.toRailDestination(
                                      destination,
                                    ),
                              )
                              .toList(),
                      backgroundColor: navRailTheme.backgroundColor,
                      selectedIconTheme: navRailTheme.selectedIconTheme,
                      unselectedIconTheme: navRailTheme.unselectedIconTheme,
                      selectedLabelTextStyle:
                          navRailTheme.selectedLabelTextStyle,
                      unSelectedLabelTextStyle:
                          navRailTheme.unselectedLabelTextStyle,
                    ),
              ),
              Breakpoints.mediumLargeAndUp: SlotLayout.from(
                key: const Key('Primary Navigation MediumLarge'),
                inAnimation: AdaptiveScaffold.leftOutIn,
                builder:
                    (_) => AdaptiveScaffold.standardNavigationRail(
                      selectedIndex: tabsRouter.activeIndex,
                      onDestinationSelected: (int newIndex) {
                        setState(() {
                          onSelectedIndexChange(newIndex);
                          tabsRouter.setActiveIndex(newIndex);
                        });
                      },
                      extended: true,
                      leading: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Text(
                            'REPLY',
                            style: TextStyle(color: colorScheme.primary),
                          ),
                          Icon(Icons.menu_open, color: colorScheme.primary),
                        ],
                      ),
                      destinations:
                          destinations
                              .map(
                                (NavigationDestination destination) =>
                                    AdaptiveScaffold.toRailDestination(
                                      destination,
                                    ),
                              )
                              .toList(),
                      trailing: trailingNavRail,
                      backgroundColor: navRailTheme.backgroundColor,
                      selectedIconTheme: navRailTheme.selectedIconTheme,
                      unselectedIconTheme: navRailTheme.unselectedIconTheme,
                      selectedLabelTextStyle:
                          navRailTheme.selectedLabelTextStyle,
                      unSelectedLabelTextStyle:
                          navRailTheme.unselectedLabelTextStyle,
                    ),
              ),
            },
          ),
          // BottomNavigation is only active in small views defined as under 600 dp
          bottomNavigation: SlotLayout(
            config: <Breakpoint, SlotLayoutConfig>{
              Breakpoints.small: SlotLayout.from(
                key: const Key('Bottom Navigation Small'),
                inAnimation: AdaptiveScaffold.bottomToTop,
                outAnimation: AdaptiveScaffold.topToBottom,
                builder:
                    (_) => AdaptiveScaffold.standardBottomNavigationBar(
                      destinations: destinations,
                      currentIndex: tabsRouter.activeIndex,
                      onDestinationSelected: (int newIndex) {
                        setState(() {
                          onSelectedIndexChange(newIndex);
                          tabsRouter.setActiveIndex(newIndex);
                        });
                      },
                    ),
              ),
            },
          ),
          // Body switches between a ListView and a GridView from small to medium
          // breakpoints and onwards.
          body: SlotLayout(
            config: <Breakpoint, SlotLayoutConfig>{
              Breakpoints.smallAndUp: SlotLayout.from(
                key: const Key('Body Small'),
                builder: activeTabIndex == 3 ? (_) => (child) : (_) => (child),
              ),
              Breakpoints.mediumLargeAndUp: SlotLayout.from(
                key: const Key('Body MediumLarge'),
                builder:
                    (_) => SizedBox(
                      width:
                          400, // Explicitly set width to avoid excessive space
                      child: child,
                    ),
              ),
            },
          ),
          secondaryBody: SlotLayout(
            config: <Breakpoint, SlotLayoutConfig>{
              Breakpoints.mediumLargeAndUp: SlotLayout.from(
                key: const Key('Secondary Body Medium'),
                builder:
                    activeTabIndex == 3
                        ? (_) => Flexible(
                          child: child, // Ensure it adjusts to remaining space
                        )
                        : null,
              ),
            },
          ),
        );
      },
    );
    // End of AutoTabsRouter workaround.
  }
}
