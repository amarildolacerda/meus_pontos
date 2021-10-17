import 'package:flutter/material.dart';
import 'package:controls_web/controls.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

import 'projeto_view.dart';

class HomeView extends StatefulWidget {
  final String title;
  const HomeView({Key? key, required this.title}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    //ResponsiveInfo responsive = ResponsiveInfo(context);
    return MobileScaffold(
        extendedBar: Container(
          height: 40,
          width: double.infinity,
          color: Colors.amber[200],
        ),
        appBar: AppBar(elevation: 0, title: Text(widget.title)),
        body: Column(
          children: [
            ListView(children: [
              Container(
                color: Colors.amber[200],
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: Row(
                    children: [
                      const Text('Projetos',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          )),
                      const Spacer(),
                      InkButton(
                          child: const Text('novo'),
                          onTap: () {
                            Get.to(() => const ProjetoView(
                                  editing: false,
                                ));
                          }),
                    ],
                  ),
                ),
              ),
            ]),
            MobileMenuBox(
              choices: [
                TabChoice(
                  label: 'Novo',
                  child: Container(),
                ),
              ],
            ),
          ],
        ));
  }
}
