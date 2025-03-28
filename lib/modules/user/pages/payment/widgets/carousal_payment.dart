import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class CarousalPayment extends StatefulWidget {
  const CarousalPayment({super.key});

  @override
  State<CarousalPayment> createState() => _CarousalPaymentState();
}

class _CarousalPaymentState extends State<CarousalPayment> {
  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
        items: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 300,
            child: Card(
              color: Colors.white,
              child: Column(
                children: [
                  Image.asset(
                    'assets/icons/payment/percent.png',
                    height: 100,
                    width: 100,
                  ),
                  const Text(
                    'Save up to 25%',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'on your bill payment',
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 300,
            child: Card(
              color: Colors.white,
              child: Column(
                children: [
                  Image.asset(
                    'assets/icons/payment/coin.png',
                    height: 100,
                    width: 100,
                  ),
                  const Text(
                    'Earn Cashbacks',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'with every transaction you make.',
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 300,
            child: Card(
              color: Colors.white,
              child: Column(
                children: [
                  Image.asset(
                    'assets/icons/payment/payment_success.png',
                    height: 100,
                    width: 100,
                  ),
                  const Text(
                    'Pay with confidence',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'all payment types is accepted.',
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
        options: CarouselOptions(
          autoPlay: true,
        ));
  }
}
