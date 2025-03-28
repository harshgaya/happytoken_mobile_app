import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:happy_tokens/modules/user/pages/category/widgets/not-found.dart';
import 'package:happy_tokens/modules/user/pages/category/widgets/restaurant_tile.dart';

import '../../../controller/user_controller.dart';
import '../../payment/enter_amount.dart';

class CategoryShopList extends StatefulWidget {
  final String categoryName;
  final String categoryId;
  const CategoryShopList(
      {super.key, required this.categoryName, required this.categoryId});

  @override
  State<CategoryShopList> createState() => _CategoryShopListState();
}

class _CategoryShopListState extends State<CategoryShopList> {
  final userController = Get.put(UserController());

  @override
  void initState() {
    super.initState();
    userController.categoryShops.value = [];
    userController.getCategoryShops(categoryName: widget.categoryId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryName),
      ),
      body: Obx(() => userController.categoryShopsLoading.value
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : userController.categoryShops.isEmpty
              ? const NotFound()
              : Padding(
                  padding: const EdgeInsets.all(20),
                  child: ListView.builder(
                      itemCount: userController.categoryShops.length,
                      itemBuilder: (context, index) {
                        final item = userController.categoryShops[index];
                        return InkWell(
                          onTap: () {
                            Get.to(
                              () => EnterAmountScreen(
                                shopData: item,
                              ),
                            );
                          },
                          child: RestaurantTile(
                            shopData: item,
                          ),
                        );
                      }),
                )),
    );
  }
}
