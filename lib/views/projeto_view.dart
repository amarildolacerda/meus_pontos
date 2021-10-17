//import 'dart:io' as io;
import 'dart:typed_data';

import 'package:controls_image/controls_image.dart';
import 'package:flutter/material.dart';
import 'package:controls_web/controls.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:controls_image/image_view.dart' as view;

import 'grid_image_paper.dart';

class ImageProviderNotifier extends ChangeNotifier {
  Uint8List? image;
  ImageProviderNotifier();
  setImage(Uint8List newValue) {
    image = newValue;
    notifyListeners();
  }
}

class ProjetoView extends StatefulWidget {
  final bool editing;
  final String? projectName;
  const ProjetoView({Key? key, this.projectName, this.editing = false})
      : super(key: key);

  @override
  State<ProjetoView> createState() => _ProjetoViewState();
}

const pixelToMM = 0.26458333333333;

class _ProjetoViewState extends State<ProjetoView> {
  Uint8List? original;
  Size? originalSize;
  String? path;
  late ImageProviderNotifier notifier;

  @override
  void initState() {
    super.initState();
    notifier = ImageProviderNotifier();
    gridChecked = true;
    pontoCountW = 130;
    pontoWidth = 9.1;
    //pontoCountH = 100;
  }

  final _formKey = GlobalKey<FormState>();
  late ResponsiveInfo responsive;
  final constrainedEvent = false.obs;
  @override
  Widget build(BuildContext context) {
    responsive = ResponsiveInfo(context);
    return ChangeNotifierProvider.value(
      value: notifier,
      builder: (_, w) => MobileScaffold(
        appBar: AppBar(elevation: 0, title: const Text('Projeto'), actions: [
          IconButton(
              icon: const Icon(Icons.camera),
              onPressed: () {
                getPicker();
              })
        ]),
        body: ListView(children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: SizedBox(
                height: 60,
                child: Form(
                  key: _formKey,
                  child: Column(children: [
                    Row(
                      children: [
                        const SizedBox(width: 10),
                        SizedBox(
                          width: 60,
                          child: TextFormField(
                            keyboardType: TextInputType.phone,
                            initialValue: '$pontoCountW',
                            onSaved: (v) {
                              pontoCountW = int.tryParse(v!) ?? pontoCountW;
                            },
                            decoration:
                                const InputDecoration(labelText: 'Pt.Larg'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        SizedBox(
                          width: 60,
                          child: TextFormField(
                              keyboardType: TextInputType.phone,
                              initialValue: '$pontoWidth',
                              decoration:
                                  const InputDecoration(labelText: 'mm/pt'),
                              onSaved: (v) {
                                pontoWidth = double.tryParse(v!) ?? pontoWidth;
                              }),
                        ),
                        InkButton(
                            child: const Text('redefinir'),
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                resize();
                                FocusScope.of(context).unfocus();
                              }
                            }),
                        const Spacer(),
                        MaskedCheckbox(
                          value: gridChecked,
                          label: 'grid',
                          onChanged: (b) {
                            setState(() {
                              gridChecked = b;
                            });
                          },
                        ),
                      ],
                    ),
                  ]),
                )),
          ),
          Consumer<ImageProviderNotifier>(
            builder: (context, value, wg) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: (responsive.orientation! == Orientation.landscape)
                      ? responsive.size.width * 0.8
                      : null,
                  height: (responsive.orientation! == Orientation.portrait)
                      ? responsive.size.height * .8
                      : null,
                  child: (value.image == null)
                      ? null
                      : LayoutBuilder(
                          builder: (a, size) => (gridChecked)
                              ? InkWell(
                                  child: Obx(() => InteractiveViewer(
                                        //minScale: 0.1,
                                        maxScale: 50.0,
                                        constrained: constrainedEvent.value,
                                        child: Builder(builder: (_) {
                                          return Wrap(children: [
                                            GridImagePaper(
                                              divisions: divisions,
                                              interval: interval,
                                              width: imageSize!.width,
                                              height: imageSize!.height,

                                              subdivisions: subdivisions,
                                              // size.maxWidth / pontoWidth ~/ 1,
                                              color: Colors.indigo,
                                              child: createImage(value.image,
                                                  constrainedEvent.value),
                                            )
                                          ]);
                                        }),
                                      )),
                                  onDoubleTap: () {
                                    constrainedEvent.value =
                                        !constrainedEvent.value;
                                  },
                                )
                              : InkWell(
                                  child: Obx(() => InteractiveViewer(
                                        constrained: constrainedEvent.value,
                                        //minScale: 0.1,
                                        maxScale: 5,
                                        child: Wrap(children: [
                                          createImage(value.image,
                                              constrainedEvent.value)
                                        ]),
                                      )),
                                  onDoubleTap: () {
                                    constrainedEvent.value =
                                        !constrainedEvent.value;
                                  },
                                ),
                        ),
                ),
              );
            },
          ),
        ]),
        bottomNavigationBar: Consumer<ImageProviderNotifier>(
            builder: (a, img, c) => SizedBox(
                  height: 35,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: Row(children: [
                      if (imageSize != null)
                        Text(
                            '${(imageSize!.width / 10) ~/ 1}  x  ${(imageSize!.height / 10) ~/ 1} cm -> $convM2 m2')
                    ]),
                  ),
                )),
      ),
    );
  }

  double get convM2 =>
      ((imageSize!.width / 100 * imageSize!.height / 100) ~/ 1) / 100;

  get interval {
    var r = (pontoWidth * (divisions * subdivisions)).toDouble();
    return r;
  }

  get divisions => 5;
  get subdivisions => 2;

  createImage(image, bool constraint) {
    var img = Image.memory(image!,
        //fit: BoxFit.none,
        fit: constraint
            ? ((responsive.orientation! == Orientation.landscape)
                ? BoxFit.fitHeight
                : BoxFit.fitWidth)
            : BoxFit.none);
    //if (image != null) imageSize = Size(img.width ?? 400, img.height ?? 300);
    return img;
  }

  //late Size imageSize;

  getPicker() async {
    Get.to(
      () => view.ImageEditorView(
        rawPath: (original == null) ? null : original!,
        canResize: false,
        useFilter: true,
        onSelected: (bytes) {
          original = bytes;
          resize();
        },
      ),
    );
  }

  late bool gridChecked;
  late int pontoCountW;
  late double pontoWidth;
  Size? imageSize;
  //late int pontoCountH;
  int get imageWidth => (pontoCountW * pontoWidth) ~/ 1;

  resize() async {
    ImagePicker.factorResize(original!, imageWidth).then((fator) {
      imageSize = Size(
          imageWidth.toDouble(), (fator.y! * fator.factor!).toInt().toDouble());

      //print([imageSize, fator.toJson()]);

      ImagePicker.resize(
              original!, imageSize!.width.toInt(), imageSize!.height.toInt())
          .then((bytes) {
        notifier.setImage(bytes!);
      });
    });
  }
}
