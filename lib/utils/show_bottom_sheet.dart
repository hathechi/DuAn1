import 'package:flutter/material.dart';

import 'package:my_app_fluter/utils/push_screen.dart';

void dialogModalBottomsheet(
    BuildContext context, String title, Function function) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30),
      ),
    ),
    builder: (context) {
      return Wrap(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
            // height: MediaQuery.of(context).size.width * 0.5,
            child: Column(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.red),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text('Are you sure you want to $title?'),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 30, 0, 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 56,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 238, 238, 238),
                                elevation: 8,
                                shape: (RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(130)))),
                            onPressed: () {
                              pop();
                            },
                            child: const Text(
                              'CANCEL',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: SizedBox(
                          height: 56,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                elevation: 8,
                                shape: (RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(130)))),
                            onPressed: () {
                              function();
                            },
                            child: Text(
                              title.toUpperCase(),
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
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
        ],
      );
    },
  );
}
