import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:happy_tokens/helpers/colors.dart';
import 'package:happy_tokens/helpers/sharedprefs.dart';
import 'package:happy_tokens/helpers/utils.dart';
import 'package:happy_tokens/modules/user/controller/user_controller.dart';
import 'package:happy_tokens/modules/user/pages/payment/enter_amount.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final userController = Get.put(UserController());
  String? name;

  getUserName() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    name = sharedPreferences.getString(SharedPreferenceKey.name);
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserName();
    fetchApi();
  }

  Future<dynamic> fetchApi() async {
    await Future.wait([
      userController.getBanners(),
      userController.getCategory(),
      userController.getVerifiedShops()
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
          top: 30,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Welcome back',
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      name ?? '',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const Icon(
                  Icons.notifications,
                  color: Color(AppColors.appMainColor),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 40,
              child: TextFormField(
                enabled: false,
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
            Obx(
              () => userController.bannerLoading.value
                  ? Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        direction: ShimmerDirection.ltr,
                        period: const Duration(seconds: 2),
                        child: Container(
                          width: Get.width,
                          height: 130,
                          color:
                              Colors.grey[300], // This will be the base shape
                        ),
                      ),
                    )
                  : CarouselSlider(
                      items: userController.banners
                          .map((e) => Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: Image.network(e.image),
                              ))
                          .toList(),
                      options: CarouselOptions(
                        autoPlay: true,
                      )),
            ),
            Obx(
              () => userController.categoryLoading.value
                  ? Padding(
                      padding: const EdgeInsets.only(top: 60),
                      child: SizedBox(
                        height: 60,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 10,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 20),
                              child: Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                direction: ShimmerDirection.ltr,
                                period: const Duration(seconds: 2),
                                child: Column(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.grey[
                                          300], // This will be the base shape
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                      height: 10,
                                      width: 50,
                                      color: Colors.grey[300],
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    )
                  : SizedBox(
                      height: 100,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Category',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            height: 60,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: userController.category.length,
                                itemBuilder: (context, index) {
                                  final item = userController.category[index];
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 20),
                                    child: Column(
                                      // crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        CircleAvatar(
                                          backgroundImage:
                                              NetworkImage(item.image),
                                          backgroundColor: Colors.yellow[300],
                                        ),
                                        Text(
                                          item.name,
                                          style: const TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                          ),
                        ],
                      ),
                    ),
            ),
            const SizedBox(
              height: 20,
            ),
            Obx(
              () => userController.loadingVerifiedShops.value
                  ? SizedBox(
                      height: 400,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 10,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              direction: ShimmerDirection.ltr,
                              period: const Duration(seconds: 2),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 150,
                                    width: 150,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300]!,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                    height: 10,
                                    width: 150,
                                    color: Colors.grey[300],
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                    height: 7,
                                    width: 150,
                                    color: Colors.grey[300],
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  : SizedBox(
                      height: 400,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Highly Recommended',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Expanded(
                            child: ListView.builder(
                                itemCount: userController.verifiedShops.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  final item =
                                      userController.verifiedShops[index];
                                  return InkWell(
                                    onTap: () {
                                      Get.to(() => EnterAmountScreen(
                                          image: item.shopImage,
                                          shopName: item.shopName,
                                          shopAddress:
                                              '${item.area}, ${item.city}'));
                                    },
                                    child: Hero(
                                      tag: 'shop',
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              height: 150,
                                              width: 150,
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  fit: BoxFit.fill,
                                                  image: NetworkImage(
                                                    item.shopImage,
                                                  ),
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            SizedBox(
                                              width: 150,
                                              child: Text(
                                                item.shopName,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 17,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 150,
                                              child: Text(
                                                overflow: TextOverflow.ellipsis,
                                                '${item.area}, ${item.city}',
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
