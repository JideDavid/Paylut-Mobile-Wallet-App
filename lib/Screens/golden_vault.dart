import 'package:flutter/material.dart';
import 'dart:math';
import 'package:paylut/models/user_model.dart';

class GoldenVault extends StatefulWidget {
  final UserDetails userDetails;
  const GoldenVault({super.key, required this.userDetails});

  @override
  // ignore: no_logic_in_create_state
  State<GoldenVault> createState() => _GoldenVaultState(userDetails: userDetails);
}

class _GoldenVaultState extends State<GoldenVault> with TickerProviderStateMixin{
  UserDetails userDetails;
  _GoldenVaultState({required this.userDetails});

  int number1 = 0;
  bool isScrolling1 = false;
  int number2 = 0;
  bool isScrolling2 = false;
  int number3 = 0;
  bool isScrolling3 = false;
  bool hasInputAmount = false;
  int amount = 0;
  int possibleEarnings = 0;
  int vaultAmount = 50000000;

  TextEditingController amountController = TextEditingController();
  Animation? animation;
  AnimationController? animationControllerGolden;

  void calculatePossibleEarnings(int amount){
    setState(() {
      Random random = Random();
      int randomNumber = random.nextInt(30) + 27; // from 10 up to 100 included
      possibleEarnings = randomNumber * amount;
    });
  }
  Future<void> updateAmountInVault() async {

    Random random = Random();
    int randomTime = random.nextInt(6) + 1; // from 1 up to 3 included
    int randomAmount = random.nextInt(9999) + 10; // from 10 up to 9999

    for(int i = 0; i < 1000 && mounted; i++){
      int oldVaultAmount = vaultAmount;
      int newVaultAmount = vaultAmount + randomAmount;
      animationControllerGolden = AnimationController(duration: const Duration(seconds: 1), vsync: this,);
      animation = IntTween(begin: oldVaultAmount, end: newVaultAmount).animate(CurvedAnimation(parent: animationControllerGolden!, curve: Curves.easeOut));
      animationControllerGolden!.forward();
      animationControllerGolden!.addListener((){
        if(mounted){
          setState(() {});
        }

      });
      vaultAmount = newVaultAmount;
      await Future.delayed(Duration(seconds: randomTime), (){});
    }

  }

  @override
  void initState() {
    super.initState();
    updateAmountInVault();
  }

  @override
  void dispose() {
    animationControllerGolden!.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    TextStyle heading = const TextStyle(
      fontWeight: FontWeight.bold,
    );
    TextStyle subHeading = const TextStyle(
      fontWeight: FontWeight.normal,
      fontSize: 12,
    );
    // TextStyle sectionHeading =
    //     const TextStyle(fontWeight: FontWeight.normal, fontSize: 14, color: Colors.deepPurple);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Golden Vault",
              style: heading,
            ),
            Text(
              "crack the vault codes to share the treasure",
              style: subHeading,
            )
          ],
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.more_vert_outlined,
              ))
        ],
        toolbarHeight: 80,
        elevation: 0,
        backgroundColor: Colors.black.withOpacity(0),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  //Amount Section
                  SizedBox(
                    child: TextField(
                      controller: amountController,
                      onChanged: (value) {
                        amount = int.tryParse(amountController.text)!;
                        if (amount < 10) {
                          setState(() {
                            hasInputAmount = false;
                            possibleEarnings = 0;
                          });
                        } else {
                          setState(() {
                            hasInputAmount = true;
                            calculatePossibleEarnings(amount);
                          });
                        }
                      },
                      maxLength: 4,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        counterText: "",
                        focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.red, width: 1.0),
                            borderRadius: BorderRadius.circular(20)),
                        enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.deepPurple, width: 1.0),
                            borderRadius: BorderRadius.circular(20)),
                        hintText: 'Enter Amount',
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  //possible earning
                  Container(
                    height: 60,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.deepPurple),
                        borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset("lib/icons/naira.png", color: Colors.red, scale: 20,),
                            Text(
                              possibleEarnings.toString(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 30,
                                  color: Colors.red),
                            ),
                          ],
                        ),
                        const Text("Possible Earnings",
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 12,
                              color: Colors.deepPurple),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  //number selection & preview
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        color: Colors.grey.withOpacity(0.2),
                        child: Column(
                          children: [
                            Expanded(
                              flex: 4,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.deepPurple, borderRadius: BorderRadius.circular(0),
                                    image: const DecorationImage(image: AssetImage("assets/patterns/dotPattern.png"),
                                        fit: BoxFit.cover),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "vault codes",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    Row(
                                      children: [
                                        //numbers
                                        Expanded(
                                            flex: 4,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                //number cards
                                                //number 1
                                                Container(
                                                  height: 50,
                                                  width: 35,
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: isScrolling1
                                                              ? Colors.red
                                                              : Colors.white),
                                                      borderRadius: BorderRadius.circular(10)),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Text(
                                                        number1.toString(),
                                                        style: const TextStyle(
                                                            fontWeight: FontWeight.normal,
                                                            fontSize: 16,
                                                            color: Colors.white),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 8,
                                                ),
                                                //number2
                                                Container(
                                                  height: 50,
                                                  width: 35,
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: isScrolling2
                                                              ? Colors.red
                                                              : Colors.white),
                                                      borderRadius: BorderRadius.circular(10)),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Text(
                                                        number2.toString(),
                                                        style: const TextStyle(
                                                            fontWeight: FontWeight.normal,
                                                            fontSize: 16,
                                                            color: Colors.white),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 8,
                                                ),
                                                //number3
                                                Container(
                                                  height: 50,
                                                  width: 35,
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: isScrolling3
                                                              ? Colors.red
                                                              : Colors.white),
                                                      borderRadius: BorderRadius.circular(10)),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Text(
                                                        number3.toString(),
                                                        style: const TextStyle(
                                                            fontWeight: FontWeight.normal,
                                                            fontSize: 16,
                                                            color: Colors.white),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 8,
                                                ),
                                              ],
                                            ))
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Image.asset("lib/icons/naira.png", color: Colors.white, scale: 30,),
                                        Text(animation!.value.toString(), style: const TextStyle(color: Colors.white, fontSize: 20),),
                                      ],
                                    ),
                                    const Text("amount in vault", style: TextStyle(color: Colors.white, fontSize: 10),),
                                  ],
                                ),
                              ),
                            ),
                            //number picker section
                            Expanded(
                              flex: 6,
                              child: Stack(alignment: AlignmentDirectional.center, children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  child: Container(
                                    width: double.infinity,
                                    height: 35,
                                    color: Colors.grey.withOpacity(0.2),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    //scroll wheel1
                                    SizedBox(
                                      width: 30,
                                      child: ListWheelScrollView.useDelegate(
                                        onSelectedItemChanged: (value) async {
                                          setState(() {
                                            if (value <= 98) {
                                              number1 = value + 1;
                                              isScrolling1 = true;
                                            } else {
                                              number1 = 99;
                                            }
                                            Future.delayed(const Duration(seconds: 1), () {
                                              isScrolling1 = false;
                                              setState(() {});
                                            });
                                          });
                                        },
                                        squeeze: 5,
                                        itemExtent: 100,
                                        perspective: 0.009,
                                        diameterRatio: 1,
                                        physics: const FixedExtentScrollPhysics(),
                                        childDelegate: ListWheelChildBuilderDelegate(
                                            childCount: 100,
                                            builder: (context, index) {
                                              return Text(
                                                index.toString(),
                                                style: TextStyle(
                                                    fontWeight: number1 == index
                                                        ? FontWeight.bold
                                                        : FontWeight.normal,
                                                    fontSize: 20,
                                                    color:
                                                        number1 == index ? Colors.red : Colors.grey),
                                              );
                                            }),
                                      ),
                                    ),
                                    const VerticalDivider(
                                      indent: 150,
                                      endIndent: 150,
                                      thickness: 2,
                                    ),
                                    //scroll wheel2
                                    SizedBox(
                                      width: 30,
                                      child: ListWheelScrollView.useDelegate(
                                        onSelectedItemChanged: (value) {
                                          setState(() {
                                            if (value <= 98) {
                                              number2 = value + 1;
                                              isScrolling2 = true;
                                            } else {
                                              number2 = 99;
                                            }
                                            Future.delayed(const Duration(seconds: 1), () {
                                              isScrolling2 = false;
                                              setState(() {});
                                            });
                                          });
                                        },
                                        squeeze: 5,
                                        itemExtent: 100,
                                        perspective: 0.009,
                                        diameterRatio: 1,
                                        physics: const FixedExtentScrollPhysics(),
                                        childDelegate: ListWheelChildBuilderDelegate(
                                            childCount: 100,
                                            builder: (context, index) {
                                              return Text(
                                                index.toString(),
                                                style: TextStyle(
                                                    fontWeight: number2 == index
                                                        ? FontWeight.bold
                                                        : FontWeight.normal,
                                                    fontSize: 20,
                                                    color:
                                                        number2 == index ? Colors.red : Colors.grey),
                                              );
                                            }),
                                      ),
                                    ),
                                    const VerticalDivider(
                                      indent: 150,
                                      endIndent: 150,
                                      thickness: 2,
                                    ),
                                    //scroll wheel3
                                    SizedBox(
                                      width: 30,
                                      child: ListWheelScrollView.useDelegate(
                                        onSelectedItemChanged: (value) {
                                          setState(() {
                                            if (value <= 98) {
                                              number3 = value + 1;
                                              isScrolling3 = true;
                                            } else {
                                              number3 = 99;
                                            }
                                            Future.delayed(const Duration(seconds: 1), () {
                                              isScrolling3 = false;
                                              setState(() {});
                                            });
                                          });
                                        },
                                        squeeze: 5,
                                        itemExtent: 100,
                                        perspective: 0.009,
                                        diameterRatio: 1,
                                        physics: const FixedExtentScrollPhysics(),
                                        childDelegate: ListWheelChildBuilderDelegate(
                                            childCount: 100,
                                            builder: (context, index) {
                                              return Text(
                                                index.toString(),
                                                style: TextStyle(
                                                    fontWeight: number3 == index
                                                        ? FontWeight.bold
                                                        : FontWeight.normal,
                                                    fontSize: 20,
                                                    color:
                                                        number3 == index ? Colors.red : Colors.grey),
                                              );
                                            }),
                                      ),
                                    ),
                                    const VerticalDivider(
                                      indent: 150,
                                      endIndent: 150,
                                      thickness: 2,
                                    ),
                                  ],
                                ),
                              ]),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          //crack vault button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: !hasInputAmount ? null : () {},
                    style: ButtonStyle(
                        backgroundColor: !hasInputAmount
                            ? const MaterialStatePropertyAll(Colors.grey)
                            : const MaterialStatePropertyAll(Colors.red),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                        )),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Text("Crack Vault"),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}


