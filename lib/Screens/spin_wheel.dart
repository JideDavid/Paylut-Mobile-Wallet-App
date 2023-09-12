import 'package:flutter/material.dart';
import 'package:paylut/models/user_model.dart';

class SpinWheel1 extends StatefulWidget {
  final UserDetails userDetails;
  const SpinWheel1({super.key, required this.userDetails});

  @override
  // ignore: no_logic_in_create_state
  State<SpinWheel1> createState() => _SpinWheel1State(userDetails: userDetails);
}

class _SpinWheel1State extends State<SpinWheel1> {
  UserDetails userDetails;
  _SpinWheel1State({required this.userDetails});

  TextStyle heading = const TextStyle(
    fontWeight: FontWeight.bold,
  );
  TextStyle subHeading = const TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 12,
  );
  TextEditingController amountController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController aliasController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Spin Wheel",
              style: heading,
            ),
            Text(
              "Spin and win huge prizes without limits",
              style: subHeading,
            )
          ],
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.history,
              ))
        ],
        toolbarHeight: 80,
        elevation: 0,
        backgroundColor: Colors.black.withOpacity(0),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Stack(children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/backgrounds/underConstruction.png'),
              const Icon(
                Icons.info,
                color: Colors.grey,
              ),
              const SizedBox(
                height: 8,
              ),
              const Center(
                child: Text(
                  'We are currently working on bringing you varieties of games. \n Please Stay tuned',
                  textAlign: TextAlign.center,
                ),
              )
            ],
          ),
        ]),
      ),
    );
  }
}
