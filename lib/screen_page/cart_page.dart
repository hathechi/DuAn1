import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CartPage extends StatefulWidget {
  final bool fromToDetail;
  const CartPage({super.key, required this.fromToDetail});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  int count = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              FontAwesomeIcons.magnifyingGlass,
              color: Colors.black,
            ),
          ),
        ],
        title: const Text(
          "Cart Page",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        automaticallyImplyLeading: widget.fromToDetail,
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 7,
                  itemBuilder: (context, index) {
                    return _itemCart();
                  },
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 255, 255, 255),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(255, 176, 176, 176),
                    offset: Offset(0.0, 1), //(x,y)
                    blurRadius: 10.0,
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Expanded(
                    flex: 2,
                    child: ListTile(
                      title: Padding(
                        padding: EdgeInsets.only(bottom: 8.0),
                        child: Text('Total Price'),
                      ),
                      subtitle: Text(
                        '\$105.0',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 26,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
                      height: 56,
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: ElevatedButton.icon(
                          icon: const Icon(FontAwesomeIcons.upRightFromSquare),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              elevation: 8,
                              shape: (RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(130)))),
                          onPressed: () {},
                          label: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'CHECK OUT',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _quantily() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            '\$24$count.0',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 253, 253, 253),
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () {
                    setState(
                      () {
                        if (count != 1) {
                          count--;
                        }
                      },
                    );
                  },
                  icon: const Icon(FontAwesomeIcons.minus),
                ),
                Text(
                  '$count',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      count++;
                    });
                  },
                  icon: const Icon(FontAwesomeIcons.plus),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _itemCart() {
    return Slidable(
      key: UniqueKey(),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        dismissible: DismissiblePane(onDismissed: () {}),
        children: [
          SlidableAction(
            borderRadius: const BorderRadius.all(
              Radius.circular(20),
            ),
            spacing: 10,
            onPressed: (context) {},
            backgroundColor: const Color.fromARGB(255, 245, 55, 55),
            // foregroundColor: Colors.white,
            icon: FontAwesomeIcons.trashCan,
            label: 'DELETE',
          ),
        ],
      ),
      child: Container(
        height: 150,
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
          color: Color.fromARGB(255, 182, 198, 217),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                  color: Color.fromARGB(255, 251, 227, 220),
                ),
                child: Image.asset('assets/images/giay1.png'),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                margin: const EdgeInsets.only(left: 10),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Air Jodan 3 Retro',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            FontAwesomeIcons.trashCan,
                            size: 22,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        'Black  |  Size = 42',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: _quantily(),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
