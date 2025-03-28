import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:happy_tokens/modules/user/pages/search/widgets/not-found-search.dart';
import 'package:happy_tokens/modules/user/pages/search/widgets/search_tile.dart';
import '../../../../../helpers/colors.dart';
import '../../../controller/user_controller.dart';

class SearchShop extends StatefulWidget {
  const SearchShop({super.key});

  @override
  State<SearchShop> createState() => _SearchShopState();
}

class _SearchShopState extends State<SearchShop> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  Timer? _debounce;
  final userController = Get.put(UserController());

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    userController.searchShopList.value = [];
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  void _onSearchTextChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    if (value.isEmpty) {
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 200), () {
      userController.getSearchShops(search: value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          children: [
            SizedBox(
              height: 40,
              child: TextFormField(
                controller: _searchController,
                focusNode: _focusNode,
                onChanged: _onSearchTextChanged,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Color(AppColors.buttonInactiveColor),
                  hintText: 'Search restaurants, fashions',
                  prefixIcon: SizedBox(
                    width: 20,
                    child: Icon(
                      Icons.search,
                      size: 20,
                      color: Colors.grey,
                    ),
                  ),
                  hintStyle: TextStyle(
                    color: Colors.black26,
                    fontSize: 12,
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 1.0, horizontal: 5.0),
                ),
              ),
            ),
            Obx(() => userController.searchShopLoading.value
                ? const Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : userController.searchShopList.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: NotFoundSearch(),
                      )
                    : Expanded(
                        child: ListView.builder(
                            itemCount: userController.searchShopList.length,
                            itemBuilder: (context, index) {
                              final item = userController.searchShopList[index];
                              return SearchTile(
                               shopData: item,
                              );
                            }),
                      )),
          ],
        ),
      ),
    );
  }
}
