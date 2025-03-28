import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:happy_tokens/modules/authentication/authentication_controller.dart';
import 'package:happy_tokens/widgets/button_no_radius.dart';
import 'package:intl/intl.dart';

class StoreHoursScreen extends StatefulWidget {
  @override
  _StoreHoursScreenState createState() => _StoreHoursScreenState();
}

class _StoreHoursScreenState extends State<StoreHoursScreen> {
  final authController = Get.put(AuthenticationController());
  final List<String> days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

  Map<String, String> storeTime = {};

  @override
  void initState() {
    super.initState();
    for (var day in days) {
      storeTime[day] = '08:00 AM - 09:00 PM';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 100,
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: const Row(
            children: [
              SizedBox(
                width: 10,
              ),
              Icon(
                Icons.arrow_back_ios_new_outlined,
                size: 15,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                'Back',
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: days.length,
                itemBuilder: (context, index) => _buildDayRow(days[index]),
              ),
            ),
            ButtonNoRadius(
              function: () {
                authController.storeTimings.value = storeTime;

                Navigator.pop(context);
              },
              text: 'Save',
              active: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDayRow(String day) {
    bool isOpen = storeTime[day] != 'Closed';
    List<String> times =
        isOpen ? storeTime[day]!.split(' - ') : ['08:00 AM', '09:00 PM'];

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(day,
                style: const TextStyle(
                    fontSize: 16.0, fontWeight: FontWeight.bold)),
            Switch(
              value: isOpen,
              onChanged: (value) {
                setState(() {
                  storeTime[day] = value ? '08:00 AM - 09:00 PM' : 'Closed';
                });
              },
            ),
            if (isOpen) ...[
              _buildTimePicker(day, times[0], true),
              const Text(' - ', style: TextStyle(fontSize: 12.0)),
              _buildTimePicker(day, times[1], false),
            ] else ...[
              const Text('Closed',
                  style: TextStyle(color: Colors.red, fontSize: 12.0)),
            ]
          ],
        ),
      ),
    );
  }

  // Widget _buildTimePicker(String day, String time, bool isStartTime) {
  //   return InkWell(
  //     onTap: () async {
  //       try {
  //         String cleanedTime = time.trim();
  //         TimeOfDay? pickedTime = await showTimePicker(
  //           context: context,
  //           initialTime: TimeOfDay.fromDateTime(
  //               DateFormat("hh:mm a").parse(cleanedTime)),
  //         );
  //
  //         if (pickedTime != null) {
  //           setState(() {
  //             String formattedTime = pickedTime.format(context);
  //             List<String> times = storeTime[day]!.split(' - ');
  //             storeTime[day] = isStartTime
  //                 ? '$formattedTime - ${times[1]}'
  //                 : '${times[0]} - $formattedTime';
  //           });
  //         }
  //       } catch (e) {
  //         print("Error parsing time: $e");
  //       }
  //     },
  //     child: Container(
  //       padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
  //       decoration: BoxDecoration(
  //         border: Border.all(color: Colors.grey),
  //         borderRadius: BorderRadius.circular(5.0),
  //       ),
  //       child: Text(time, style: const TextStyle(fontSize: 12.0)),
  //     ),
  //   );
  // }
  Widget _buildTimePicker(String day, String time, bool isStartTime) {
    return InkWell(
      onTap: () async {
        try {
          String cleanedTime = time.trim();
          TimeOfDay initialTime =
              TimeOfDay.fromDateTime(DateFormat("hh:mm a").parse(cleanedTime));

          TimeOfDay? pickedTime = await showTimePicker(
            context: context,
            initialTime: initialTime,
          );

          if (pickedTime != null) {
            setState(() {
              // Convert TimeOfDay to DateTime for proper formatting
              final now = DateTime.now();
              final selectedDateTime = DateTime(
                now.year,
                now.month,
                now.day,
                pickedTime.hour,
                pickedTime.minute,
              );

              // Format time correctly with AM/PM
              String formattedTime =
                  DateFormat("hh:mm a").format(selectedDateTime);

              List<String> times = storeTime[day]!.split(' - ');
              storeTime[day] = isStartTime
                  ? '$formattedTime - ${times[1]}'
                  : '${times[0]} - $formattedTime';
            });
          }
        } catch (e) {
          print("Error parsing time: $e");
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Text(time, style: const TextStyle(fontSize: 12.0)),
      ),
    );
  }
}
