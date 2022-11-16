// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_app_fluter/screen_page/enter_pin_screen.dart';
import 'package:my_app_fluter/utils/push_screen.dart';

class ChoocePayMent extends StatefulWidget {
  const ChoocePayMent({super.key});

  @override
  State<ChoocePayMent> createState() => _ChoocePayMentState();
}

class _ChoocePayMentState extends State<ChoocePayMent> {
  List<Payment> listPayment = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    listPayment.add(
      Payment(
          icon: const Icon(
            FontAwesomeIcons.wallet,
            color: Colors.amber,
            size: 28,
          ),
          name: 'My Wallet'),
    );
    listPayment.add(
      Payment(
          icon: const Icon(
            FontAwesomeIcons.paypal,
            color: Colors.blue,
            size: 28,
          ),
          name: 'PayPal'),
    );
    listPayment.add(
      Payment(
          icon: const Icon(
            FontAwesomeIcons.googlePay,
            color: Colors.red,
            size: 28,
          ),
          name: 'Google Pay'),
    );
    listPayment.add(
      Payment(
          icon: const Icon(
            FontAwesomeIcons.applePay,
            color: Colors.black,
            size: 28,
          ),
          name: 'Apple Pay'),
    );
    listPayment.add(
      Payment(
          icon: const Icon(
            FontAwesomeIcons.ccMastercard,
            color: Color.fromARGB(255, 152, 11, 1),
            size: 28,
          ),
          name: 'Master Cart'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Chooce Payment',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 20),
                      child: const Text(
                        'Select the payment menthod you want to use.',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 10,
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: listPayment.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () => pushScreen(context, const EnterPin()),
                            splashColor: Colors.pink,
                            child: Container(
                              height: 100,
                              margin: const EdgeInsets.all(10),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color:
                                      const Color.fromARGB(255, 224, 224, 224)),
                              child: Row(
                                children: [
                                  //Icon
                                  CircleAvatar(
                                    radius: 40,
                                    backgroundColor: Colors.white,
                                    child: listPayment[index].icon!,
                                  ),
                                  const SizedBox(
                                    width: 30,
                                  ),
                                  Text(
                                    listPayment[index].name!,
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
            //   child: SizedBox(
            //     width: double.infinity,
            //     height: 56,
            //     child: Directionality(
            //       textDirection: TextDirection.rtl,
            //       child: ElevatedButton.icon(
            //         style: ElevatedButton.styleFrom(
            //             backgroundColor: Colors.black,
            //             elevation: 8,
            //             shape: (RoundedRectangleBorder(
            //                 borderRadius: BorderRadius.circular(130)))),
            //         onPressed: () {
            //           pushScreen(context, const EnterPin());
            //         },
            //         label: const Text(
            //           'Comfirm Payment',
            //           style: TextStyle(fontWeight: FontWeight.bold),
            //         ),
            //         icon: const Icon(
            //           FontAwesomeIcons.chevronRight,
            //           size: 18,
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

class Payment {
  Widget? icon;
  String? name;
  Payment({
    this.icon,
    this.name,
  });
}
