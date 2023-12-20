import "package:card_swiper/card_swiper.dart";
import "package:flutter/material.dart";
import "package:paylut/services/pref_helper.dart";

class OnBoarding extends StatefulWidget {
  const OnBoarding({super.key});

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {


  bool showLogo = true;

  SwiperController swipeControl = SwiperController();

  void showLogoTimer(){
    Future.delayed(const Duration(seconds: 3),(){
      if(mounted){
        setState(() {
          showLogo = false;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    showLogoTimer();
  }

  @override
  Widget build(BuildContext context) {

    Widget myWidget1 = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/backgrounds/onboard1.png',
                  height: 300,
                ),
              ],
            ),
          ),
          const Expanded(
            flex: 1,
            child: Column(
              children: [
                Text(
                  "Easy Bill Payment",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30, color: Colors.red),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  child: Text(
                      "Welcome to paylut where you can pay your bills hassle-free, Internet, Cable Tv, utilities and more - all in one place",
                  textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Text(
                    'swipe',
                    style: TextStyle(color: Colors.grey.withOpacity(0.5)),
                  ),
                  Icon(Icons.arrow_forward_outlined, color: Colors.grey.withOpacity(0.5)),
                ],
              )
            ],
          ),
          const SizedBox(
            height: 50,
          )
        ],
      ),
    );
    Widget myWidget2 = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/backgrounds/onboard2.png',
                  height: 300,
                ),
              ],
            ),
          ),
          const Expanded(
            flex: 1,
            child: Column(
              children: [
                Text(
                  "Earn Rewards",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30, color: Colors.red),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  child: Text(
                    "Earn rewards for every transaction, unlock exclusive offers and discounts.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Text(
                    'swipe',
                    style: TextStyle(color: Colors.grey.withOpacity(0.5)),
                  ),
                  Icon(Icons.arrow_forward_outlined, color: Colors.grey.withOpacity(0.5)),
                ],
              )
            ],
          ),
          const SizedBox(
            height: 50,
          )
        ],
      ),
    );
    Widget myWidget3 = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/backgrounds/onboard3.png',
                  height: 300,
                ),
              ],
            ),
          ),
          const Expanded(
            flex: 1,
            child: Column(
              children: [
                Text(
                  "Bet With Confidence",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30, color: Colors.red),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  child: Text(
                    "Top up your betting wallet instantly. Your winning streak starts here. "
                        "Play exciting lottery games and stand a chance to win BIG prizes!",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Text(
                    'swipe',
                    style: TextStyle(color: Colors.grey.withOpacity(0.5)),
                  ),
                  Icon(Icons.arrow_forward_outlined, color: Colors.grey.withOpacity(0.5)),
                ],
              )
            ],
          ),
          const SizedBox(
            height: 50,
          )
        ],
      ),
    );
    Widget myWidget4 = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/backgrounds/onboard4.png',
                  height: 300,
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              children: [
                const Text(
                  "Your Security Matters",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30, color: Colors.red),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  child: Text(
                    "Rest easy knowing your transactions are safe and secure with Paylut",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, color: Colors.grey),
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    PrefHelper().setAppIsFresh(false);
                    Navigator.pushReplacementNamed(context, "/authScreen");
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.red)
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 60, vertical: 12),
                      child: Text("Get Started",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                    ),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 50,
          )
        ],
      ),
    );

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: showLogo ? Center(
          child: Image.asset('lib/icons/paylut_logo.png', height: 100,),
        )
        : Swiper(
          loop: false,
          itemBuilder: (BuildContext context, int index) {
            return index == 0
                ? myWidget1
                : index == 1
                    ? myWidget2
                    : index == 2
                        ? myWidget3
                        : myWidget4;
          },
          itemCount: 4,
          pagination: const SwiperPagination(),
          control: const SwiperControl(
            size: 0,
          ),
        ),
      ),
    );
  }
}
