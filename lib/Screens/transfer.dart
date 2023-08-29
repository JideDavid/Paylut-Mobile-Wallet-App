import 'package:flutter/material.dart';
import 'package:paylut/models/user_model.dart';

class Transfer extends StatefulWidget {
  final UserDetails userDetails;
  const Transfer({super.key, required this.userDetails});

  @override
  // ignore: no_logic_in_create_state
  State<Transfer> createState() => _TransferState(userDetails: userDetails);
}

class _TransferState extends State<Transfer> {
  final UserDetails userDetails;
  _TransferState({required this.userDetails});

  TextStyle heading = const TextStyle(
    fontWeight: FontWeight.bold,
  );
  TextStyle subHeading = const TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 12,
  );

  TextEditingController userTagController = TextEditingController();

  bool hasValue = false;




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
              "Transfer",
              style: heading,
            ),
            Text(
              "Make wallet transfer to your friends",
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
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          //enter wallet Tag
          TextField(
            controller: userTagController,
            onChanged: (value) {},
            maxLength: 6,
            keyboardType: TextInputType.text,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              counterText: "",
              focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.red, width: 1.0),
                  borderRadius: BorderRadius.circular(20)),
              enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.deepPurple, width: 1.0),
                  borderRadius: BorderRadius.circular(20)),
              hintText: 'Enter UserTag',
            ),
          ),
          const Spacer(),

          hasValue ? //fund wallet button
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: (){},
                  style: ButtonStyle(
                      backgroundColor: const MaterialStatePropertyAll(Colors.red),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                      )),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Text("Fund Wallet"),
                  ),
                ),
              ),
            ],
          )
          : Expanded(child: Container(color: Colors.grey)),



          const SizedBox(height: 16,)
        ]),
      ),
    );
  }
}
