import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:happy_tokens/modules/authentication/pages/shop/shop_info_3.dart';
import 'package:happy_tokens/widgets/button_no_radius.dart';
import 'package:location_picker_flutter_map/location_picker_flutter_map.dart';
import 'package:map_picker/map_picker.dart';

import '../../authentication_controller.dart';

class ShopInfo2 extends StatefulWidget {
  const ShopInfo2({super.key});

  @override
  State<ShopInfo2> createState() => _ShopInfo2State();
}

class _ShopInfo2State extends State<ShopInfo2> {
  final authController = Get.put(AuthenticationController());
  final _controller = Completer<GoogleMapController>();
  MapPickerController mapPickerController = MapPickerController();

  CameraPosition cameraPosition = const CameraPosition(
    target: LatLng(19.2041136, 72.8517376),
    zoom: 14.4746,
  );
  String? city;
  String? state;
  String? pincode;

  var textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          MapPicker(
            // pass icon widget
            iconWidget: Image.asset(
              'assets/icons/shop_details/pin.png',
              height: 50,
            ),

            mapPickerController: mapPickerController,
            child: GoogleMap(
              myLocationEnabled: true,
              zoomControlsEnabled: false,
              myLocationButtonEnabled: false,
              mapType: MapType.normal,
              initialCameraPosition: cameraPosition,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              onCameraMoveStarted: () {
                mapPickerController.mapMoving!();
                textController.text = "checking ...";
              },
              onCameraMove: (cameraPosition) {
                this.cameraPosition = cameraPosition;
              },
              onCameraIdle: () async {
                mapPickerController.mapFinishedMoving!();

                List<Placemark> placemarks = await placemarkFromCoordinates(
                  cameraPosition.target.latitude,
                  cameraPosition.target.longitude,
                );
                city = placemarks.first.locality;
                pincode = placemarks.first.postalCode;
                state = placemarks.first.administrativeArea;
                textController.text =
                    '${placemarks.first.name},${placemarks.first.locality} ${placemarks.first.administrativeArea}, ';
              },
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).viewPadding.top + 20,

            // height: 50,
            child: Container(
              width: MediaQuery.of(context).size.width - 20,
              height: 50,
              padding: const EdgeInsets.only(left: 10, right: 10),
              color: Colors.white,
              child: Center(
                child: TextFormField(
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  readOnly: true,
                  decoration: const InputDecoration(
                      contentPadding: EdgeInsets.zero,
                      border: InputBorder.none),
                  controller: textController,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 24,
            left: 24,
            right: 24,
            child: SizedBox(
              height: 50,
              child: ButtonNoRadius(
                  function: () {
                    print(
                        "Location ${cameraPosition.target.latitude} ${cameraPosition.target.longitude}");
                    print("Address: ${textController.text}");
                    authController.latitude.value =
                        cameraPosition.target.latitude;
                    authController.longitude.value =
                        cameraPosition.target.longitude;
                    authController.city.value = city ?? '';
                    authController.state.value = state ?? '';
                    Get.to(() => ShopInfo3(
                          pincode: pincode ?? '',
                          city: city ?? '',
                        ));
                  },
                  text: 'Next',
                  active: true),
            ),
          )
        ],
      ),
    );
  }
}
