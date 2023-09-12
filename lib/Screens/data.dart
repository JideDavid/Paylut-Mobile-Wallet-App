import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:paylut/models/saved_numbers.dart';
import 'package:paylut/models/user_model.dart';
import 'package:http/http.dart' as http;

class Data extends StatefulWidget {
  final UserDetails userDetails;
  const Data({super.key, required this.userDetails});

  @override
  // ignore: no_logic_in_create_state
  State<Data> createState() => _DataState(userDetails: userDetails);
}

class _DataState extends State<Data> {
  UserDetails userDetails;
  _DataState({required this.userDetails});

  int activeIndex = 0;
  int mtnIndex = 1;
  int airtelIndex = 2;
  int gloIndex = 3;
  int mobile9Index = 4;
  int amount = 0;
  int phone = 0;
  String alias = '';
  String phoneNum = '';
  bool saveNumber = false;
  bool hasAmount = false;
  bool hasNumber = false;
  bool selectedProvider = false;
  bool selectedService = false;
  int serviceIndex = 0;
  int selectedProviderIndex = 0;
  bool isReady = false;
  bool loading = false;
  List<dynamic> serviceList = [];
  List<Number> savedNumbers = [];

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

  Future<void> getSavedNumbers() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userDetails.uid)
        .collection('savedNumbers')
        .get();
    savedNumbers = [];

    if (snapshot.docs.isEmpty) {
      if (kDebugMode) {
        print('no saved numbers');
      }
    } else {
      var docs = snapshot.docs;
      for (var doc in docs) {
        savedNumbers.add(Number.fromJson(doc));
      }
      if (kDebugMode) {
        print('got saved numbers');
      }
    }

    //sorting numbers based on use times
    savedNumbers.sort((a, b) => b.useTime.compareTo(a.useTime));
    setState(() {});
  }

  validateForm() {
    if (kDebugMode) {
      print('hasAmount: $hasAmount, hasNumber: $hasNumber, selectedProvider: $selectedProvider');
    }

    if (hasAmount && hasNumber && selectedProvider) {
      setState(() {
        isReady = true;
      });
    } else {
      setState(() {
        isReady = false;
      });
    }
  }

  saveNewNumber() async {
    //check if number exists
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userDetails.uid)
        .collection('savedNumbers')
        .doc(phoneNum)
        .get();

    //only update doc if snapshot exists
    if (snapshot.exists) {
      int useTime = snapshot.get('useTime');
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userDetails.uid)
          .collection('savedNumbers')
          .doc(phoneNum)
          .update({
        'number': phoneNum,
        'providerIndex': activeIndex,
        'alias': alias.isEmpty ? "--" : alias,
        'useTime': useTime + 1
      });
    } else {
      //create document if snapshot does not exist
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userDetails.uid)
          .collection('savedNumbers')
          .doc(phoneNum)
          .set({
        'number': phoneNum,
        'providerIndex': activeIndex,
        'alias': alias.isEmpty ? "--" : alias,
        'useTime': 1
      });
    }

    getSavedNumbers();

    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('$phoneNum has been added to your list'),
      backgroundColor: Colors.green,
      duration: const Duration(seconds: 2),
    ));
  }

  updateUseTime() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userDetails.uid)
        .collection('savedNumbers')
        .doc(phoneNum)
        .get();

    if (snapshot.exists) {
      int initialUseTime = snapshot.get('useTime');
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userDetails.uid)
          .collection('savedNumbers')
          .doc(phoneNum)
          .update({'useTime': initialUseTime + 1});
    } else {
      if (kDebugMode) {
        print('number is not saved');
      }
    }
  }

  removeFromDataBase(int index) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userDetails.uid)
        .collection('savedNumbers')
        .doc(savedNumbers[index].number)
        .delete();
  }

  removeNumber(int index) async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            //backgroundColor: Colors.green,
            title: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Confirm delete',
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ),
            content: SizedBox(
                height: 100,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 16,
                      ),
                      Text(
                        'Do you want to remove ${savedNumbers[index].number}, '
                            'with alias ${savedNumbers[index].alias} ?',
                        style: const TextStyle(),
                        textAlign: TextAlign.center,
                      )
                    ])),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Center(
                        child: Row(
                          children: [
                            Icon(
                              Icons.cancel_outlined,
                              color: Colors.red,
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            Text(
                              'Cancel',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      )),
                  TextButton(
                      onPressed: () async {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: Colors.red,
                          content: Text("${savedNumbers[index].number} has been removed"),
                          duration: const Duration(seconds: 2),
                        ));
                        removeFromDataBase(index);
                        savedNumbers.remove(savedNumbers[index]);
                        setState(() {});
                        Navigator.of(context).pop();
                      },
                      child: const Center(
                        child: Row(
                          children: [
                            Icon(
                              Icons.check_circle_outline,
                              color: Colors.green,
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            Text(
                              'Confirm',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ],
          );
        });
  }

  Future<bool> getServiceList() async{
    loading = true;
    if(mounted){
      setState(() {});
    }

    var url = Uri.parse('https://api.ufitpay.com/v1/packages');
    var response = await http.post(url, headers: {
      'API-Key': 'pub-budBcbJGG4N3sbVse2pyia5K822rYafo',
      'API-Token': 'sec-Hro8tuka5titYc5ah5bg6bgQuwGxnsfR',
    },
      body: {
        'service_id': '0002',
        'vendor_id': activeIndex == 1 ? '0023' : activeIndex == 2 ? '0026'
            : activeIndex == 3 ? '0024' : '0025'
      }
    );


    if(response.statusCode == 200){
      Map res = jsonDecode(response.body);
      var data = res['data'];
      serviceList = data;

      if(kDebugMode){
        print(data.runtimeType);
        print(data);
      }
      loading = false;
      if(mounted){
        setState(() {});
      }
      return true;
    }else{
      loading = false;
      if(mounted){
        setState(() {});
      }
      return false;
    }

  }

  selectServiceIndex(int index){
    serviceIndex = index;
    selectedService = true;
    selectedProviderIndex = activeIndex;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getSavedNumbers();
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
              "Data",
              style: heading,
            ),
            Text(
              "Data subscription to your favourite network",
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
        child: Column(
          children: [
            //phone number text field
            TextField(
              controller: phoneController,
              onChanged: (value) {
                if (value.isEmpty) {
                  phone = 0;
                  phoneNum = '';
                  hasNumber = false;
                  validateForm();
                  return;
                } else {
                  phone = int.tryParse(value)!;
                  phoneNum = value;
                  if (phone > 0 && phoneController.text.length == 11) {
                    hasNumber = true;
                  } else {
                    hasNumber = false;
                  }
                  validateForm();
                }
              },
              maxLength: 11,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                counterText: "",
                focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.red, width: 1.0),
                    borderRadius: BorderRadius.circular(20)),
                enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                    borderRadius: BorderRadius.circular(20)),
                hintText: 'Enter phone number',
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            //select plan
            Visibility(
                visible: selectedProvider,
                child: Column(
                  children: [
                    GestureDetector(
                      onTapUp: (tapDetails) async{
                        bool success = await getServiceList();
                        // ignore: use_build_context_synchronously
                        showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return StatefulBuilder(builder: (context, setState){
                                return Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 8),
                                      child: Container(
                                        height: 4, width: 32,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20),
                                          color: Colors.grey
                                        ),
                                      ),
                                    ),
                                    Text('${activeIndex == 1 ? 'MTN'
                                        : activeIndex == 2 ? 'Airtel'
                                        : activeIndex == 3 ? 'Glo'
                                        : '9Mobile'} service list',
                                    style: const TextStyle(fontWeight: FontWeight.bold),),
                                    const SizedBox(height: 12,),
                                    Expanded(
                                      child: success ? ListView.builder(
                                          itemCount: serviceList.length,
                                          itemBuilder: (context, index){
                                        
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 16),
                                          child: GestureDetector(
                                            onTap: (){
                                              selectServiceIndex(index);
                                              Navigator.of(context).pop();
                                            },
                                            child: Card(
                                              elevation: 0,
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 12),
                                                child: Center(
                                                    child:
                                                    Text(serviceList[index]['package_name'])
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      })
                                      : const Text('Error! Please reload'),
                                    )
                                  ],
                                );
                              });
                            });
                      },
                      child: Container(
                        height: 50,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.red)),
                        child: Center(child:
                        loading ? const SizedBox(
                          height: 16, width: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.red,
                            ))
                        : selectedService ? Text(
                            '${serviceList[serviceIndex]['package_name']} '
                                ' ${ selectedProviderIndex == 1 ? 'MTN'
                            : selectedProviderIndex == 2 ? 'Airtel'
                            : selectedProviderIndex == 3 ? 'GLO'
                            : '9Mobile'}'
                        )
                        : const Text('- Select Plan -',
                        style: TextStyle(color: Colors.red),)),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                  ],
                )),

            //number alias text field
            Visibility(
              visible: saveNumber,
              child: Column(
                children: [
                  TextField(
                    controller: aliasController,
                    onChanged: (value) {
                      alias = value;
                    },
                    maxLength: 11,
                    keyboardType: TextInputType.text,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      counterText: "",
                      focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.red, width: 1.0),
                          borderRadius: BorderRadius.circular(20)),
                      enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                          borderRadius: BorderRadius.circular(20)),
                      hintText: 'Enter alias for number',
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                ],
              ),
            ),

            //provider list
            SizedBox(
              height: 80,
              child: Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: GestureDetector(
                        onTap: () {
                          if( activeIndex == mtnIndex){
                            return;
                          }else{
                            selectedService = false;
                            activeIndex = mtnIndex;
                            if (kDebugMode) {
                              print('set active index to $activeIndex');
                            }
                            setState(() {});
                            selectedProvider = true;
                            validateForm();
                          }

                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.2),
                              image: DecorationImage(
                                  image: AssetImage(activeIndex == mtnIndex
                                      ? 'assets/backgrounds/mtnlogo.png'
                                      : 'assets/backgrounds/mtnlogoB.png'),
                                  fit: BoxFit.cover)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: GestureDetector(
                        onTap: () {
                          if(activeIndex == airtelIndex){
                            return;
                          }else{
                            selectedService = false;
                            activeIndex = airtelIndex;
                            if (kDebugMode) {
                              print('set active index to $activeIndex');
                            }
                            setState(() {});
                            selectedProvider = true;
                            validateForm();
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.2),
                              image: DecorationImage(
                                  image: AssetImage(activeIndex == airtelIndex
                                      ? 'assets/backgrounds/airtellogo.png'
                                      : 'assets/backgrounds/airtellogoB.png'),
                                  fit: BoxFit.cover)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: GestureDetector(
                        onTap: () {
                          if(activeIndex ==gloIndex){
                            return;
                          }else{
                            selectedService = false;
                            activeIndex = gloIndex;
                            if (kDebugMode) {
                              print('set active index to $activeIndex');
                            }
                            setState(() {});
                            selectedProvider = true;
                            validateForm();
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.2),
                              image: DecorationImage(
                                  image: AssetImage(activeIndex == gloIndex
                                      ? 'assets/backgrounds/glologo.png'
                                      : 'assets/backgrounds/glologoB.png'),
                                  fit: BoxFit.cover)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: GestureDetector(
                        onTap: () {
                          if(activeIndex == mobile9Index){
                            return;
                          }else{
                            selectedService = false;
                            activeIndex = mobile9Index;
                            if (kDebugMode) {
                              print('set active index to $activeIndex');
                            }
                            setState(() {});
                            selectedProvider = true;
                            validateForm();
                          }

                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.2),
                              image: DecorationImage(
                                  image: AssetImage(activeIndex == mobile9Index
                                      ? 'assets/backgrounds/mobile9logo.png'
                                      : 'assets/backgrounds/mobile9logoB.png'),
                                  fit: BoxFit.cover)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                ],
              ),
            ),
            //save toggle
            Row(
              children: [
                const Text('Save to beneficiary'),
                Switch(
                    value: saveNumber,
                    activeColor: Colors.red,
                    activeTrackColor: Colors.red.withOpacity(0.4),
                    onChanged: (value) {
                      setState(() {
                        saveNumber = value;
                      });
                    }),
              ],
            ),
            //saved number
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.red, width: 1.5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Container(
                        color: Colors.red.withOpacity(0.2),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Saved numbers'),
                              Icon(
                                Icons.contacts,
                                size: 18,
                                color: Colors.red,
                              ),
                            ],
                          ),
                        ),
                      ),
                      savedNumbers.isEmpty
                          ? const Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.info_outline_rounded),
                                      SizedBox(
                                        width: 4,
                                      ),
                                      Center(
                                        child: Text('No saved number'),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          : Expanded(
                              child: ListView.builder(
                                  itemCount: savedNumbers.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          activeIndex = savedNumbers[index].providerIndex;
                                          phoneController.text = savedNumbers[index].number;
                                          phone = int.parse(savedNumbers[index].number);
                                          phoneNum = savedNumbers[index].number;
                                          hasNumber = true;
                                          selectedProvider = true;
                                          validateForm();
                                        });
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.fromLTRB(16, index == 0 ? 8 : 0, 16,
                                            index == savedNumbers.length - 1 ? 16 : 4),
                                        child: Container(
                                          width: double.infinity,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            color: Colors.grey.withOpacity(0.1),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 16),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: Text(
                                                    savedNumbers[index].alias,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    children: [
                                                      Icon(
                                                        Icons.circle,
                                                        size: 12,
                                                        color: savedNumbers[index].providerIndex ==
                                                                1
                                                            ? Colors.yellow
                                                            : savedNumbers[index].providerIndex == 2
                                                                ? Colors.red
                                                                : savedNumbers[index]
                                                                            .providerIndex ==
                                                                        3
                                                                    ? Colors.green
                                                                    : Colors.green[900],
                                                      ),
                                                      const SizedBox(
                                                        width: 8,
                                                      ),
                                                      Text(
                                                        savedNumbers[index].number,
                                                        style: const TextStyle(
                                                            fontWeight: FontWeight.bold),
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                      const SizedBox(
                                                        width: 16,
                                                      ),
                                                      IconButton(
                                                          onPressed: () {
                                                            removeNumber(index);
                                                          },
                                                          icon: const Icon(
                                                              Icons.remove_circle_outline))
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
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
            ),
            const SizedBox(
              height: 16,
            ),
            //Buy airtime button
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: isReady
                          ? () {
                              if (saveNumber) {
                                saveNewNumber();
                              } else {
                                updateUseTime();
                              }
                            }
                          : null,
                      style: ButtonStyle(
                          backgroundColor: isReady
                              ? const MaterialStatePropertyAll(Colors.red)
                              : const MaterialStatePropertyAll(Colors.grey),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                          )),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Text(
                          "Buy Airtime",
                          style: TextStyle(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
