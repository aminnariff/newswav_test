import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:lottie/lottie.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ExamplePage extends StatefulWidget {
  const ExamplePage({super.key});

  @override
  State<ExamplePage> createState() => _ExamplePageState();
}

class _ExamplePageState extends State<ExamplePage> {
  Future<List<Widget>>? images;
  int items = 0;
  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 1000), () {
      setState(() {
        items = 4;
        images = getImage();
      });
    });
    super.initState();
  }

  void _onRefresh() async {
    await Future.delayed(const Duration(milliseconds: 2000));
    setState(() {
      items = items + 4;
      images = getImage();
    });
    _refreshController.refreshCompleted();
  }

  Future<List<Widget>> getImage() async {
    List<Widget> temp = [];
    return await Future.delayed(const Duration(milliseconds: 2300), () {
      for (int i = 0; i < 4; i++) {
        temp.add(Image.network(
          'https://picsum.photos/200/250?random=$i',
          width: 200,
          height: 250,
          fit: BoxFit.cover,
        ));
      }
      return temp;
    });
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(const Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    if (mounted) {
      setState(() {});
    }
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          actions: const [
            Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: Icon(
                Icons.add_circle_outlined,
                color: Colors.redAccent,
              ),
            ),
          ],
          title: Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 8.0, 0, 8.0),
            child: TextFormField(
              controller: TextEditingController(
                text: 'Newswav',
              ),
              cursorColor: Colors.redAccent,
              decoration: InputDecoration(
                fillColor: const Color(0xFFEAF2FA),
                prefixIcon: const Icon(
                  Icons.search,
                  color: Colors.redAccent,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 15),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.transparent, width: 1.0),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.redAccent.withOpacity(.1), width: 1.0),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.redAccent.withOpacity(.1), width: 1.0),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.red, width: 2.0),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                disabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.transparent, width: 0.0),
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ),
          )),
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: false,
        header: CustomHeader(
          builder: (BuildContext context, RefreshStatus? mode) {
            Widget body;
            if (mode == RefreshStatus.idle) {
              body = const Text("pull down to refresh");
            } else if (mode == RefreshStatus.refreshing) {
              body = Lottie.asset('assets/lottie/loading.json');
            } else if (mode == RefreshStatus.failed) {
              body = const Text("Refresh Failed!");
            } else if (mode == RefreshStatus.canRefresh) {
              body = const Text("release to refresh");
            } else {
              body = const Text("Refreshed completed");
            }
            return SizedBox(
              height: 55.0,
              child: Center(child: body),
            );
          },
        ),
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: content(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 0,
        selectedItemColor: Colors.redAccent,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.newspaper),
            label: 'News',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorite',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget content() {
    return MasonryGridView.count(
      itemCount: items,
      crossAxisCount: 2,
      mainAxisSpacing: 4,
      crossAxisSpacing: 4,
      itemBuilder: (context, index) {
        return Image.network(
          'https://picsum.photos/200/250?random=${items - index}}',
          width: 200,
          height: index % 3 == 0 ? 300 : 250,
          fit: BoxFit.cover,
        );
      },
    );
  }
}
