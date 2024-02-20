import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:public_display_application/enums.dart';
import 'package:public_display_application/generated/l10n.dart';
import 'package:public_display_application/models/speiseplan_item.dart';
import 'package:public_display_application/viewmodels/userviewmodel.dart';
import 'package:public_display_application/widgets/mensa/mensa_filters_widget.dart';

class MensaContent extends StatefulWidget {
  Map<int, List<SpeisePlanItem>> data;

  MensaContent({
    required this.data,
  });
  @override
  State<StatefulWidget> createState() {
    return _MensaContentState();
  }
}

class _MensaContentState extends State<MensaContent> {
  String? selectedCategory;
  TextEditingController searchController = TextEditingController();
  int day = DateTime.now().weekday - 1;
  late List<int> timestamps;
  String veganIconUrl =
      "https://www.stw-edu.de/typo3conf/ext/ddfbasics/Resources/Public/Ddf/VueMensaPlan/dist/vegan.svg";
  String porkIconUrl =
      "https://www.stw-edu.de/typo3conf/ext/ddfbasics/Resources/Public/Ddf/VueMensaPlan/dist/schwein.svg";
  String chickenIconUrl =
      "https://www.stw-edu.de/typo3conf/ext/ddfbasics/Resources/Public/Ddf/VueMensaPlan/dist/huhn.svg";
  String brocoliIconUrl =
      "https://www.stw-edu.de/typo3conf/ext/ddfbasics/Resources/Public/Ddf/VueMensaPlan/dist/vegetarisch.svg";
  String fischIconUrl =
      "https://www.stw-edu.de/typo3conf/ext/ddfbasics/Resources/Public/Ddf/VueMensaPlan/dist/fisch.svg";
  String cowIconUrl =
      "https://www.stw-edu.de/typo3conf/ext/ddfbasics/Resources/Public/Ddf/VueMensaPlan/dist/rind.svg";
  String alcoholIconUrl =
      "https://www.stw-edu.de/typo3conf/ext/ddfbasics/Resources/Public/Ddf/VueMensaPlan/dist/alk.svg";
  @override
  void initState() {
    timestamps = widget.data.keys.toList();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context
          .read<UserViewModel>()
          .getPreference(PreferenceTypes.mensa, context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          MensaFiltersWidget(),
          dateWidget(),
          Consumer<UserViewModel>(
            builder: (context, userViewModel, child) {
              return Expanded(
                child: ListView.builder(
                  itemCount: widget.data[timestamps[day]]!.length,
                  itemBuilder: (context, index) {
                    SpeisePlanItem item = widget.data[timestamps[day]]![index];
                    if (userViewModel.mensaPreference != null &&
                        userViewModel.mensaPreference!.values.isNotEmpty) {
                      final itemIconsList = item.kennz_icons!.split(',');
                      if (userViewModel.mensaPreference!.values
                          .any((element) => itemIconsList.contains(element))) {
                        return ListTile(
                          leading: setUpItemIcon(item.kennz_icons!),
                          onTap: () => essenDialog(item),
                          title: Text(item.title!),
                          trailing: Container(
                            width: 100,
                            child: Column(
                              children: [
                                const Icon(Icons.touch_app),
                                Row(
                                  children: [
                                    Text(
                                      "${item.preis1!}€",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      "${item.preis2!}€",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      "${item.preis3!}€",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return SizedBox.shrink();
                      }
                    } else {
                      return ListTile(
                        leading: setUpItemIcon(item.kennz_icons!),
                        onTap: () => essenDialog(item),
                        title: Text(item.title!),
                        trailing: Container(
                          width: 100,
                          child: Column(
                            children: [
                              const Icon(Icons.touch_app),
                              Row(
                                children: [
                                  Text(
                                    "${item.preis1!}€",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "${item.preis2!}€",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "${item.preis3!}€",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget dateWidget() {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(
      timestamps[day] * 1000,
    );
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () => setState(() {
            if (day > 0) {
              day--;
            }
          }),
          icon: const Icon(
            Icons.arrow_left,
            size: 30,
          ),
        ),
        Text(
            "${weekdayString(date.weekday)}, ${date.day}.${date.month}.${date.year}",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            )),
        IconButton(
          onPressed: () => setState(() {
            if (day < 6) {
              day++;
              print(day);
            }
          }),
          icon: const Icon(
            Icons.arrow_right,
            size: 30,
          ),
        ),
      ],
    );
  }

  String weekdayString(int day) {
    switch (day) {
      case 1:
        return S.of(context).monday;
      case 2:
        return S.of(context).tuesday;
      case 3:
        return S.of(context).wednesday;
      case 4:
        return S.of(context).thursday;
      case 5:
        return S.of(context).friday;
      case 6:
        return S.of(context).saturday;
      case 7:
        return S.of(context).sonday;
      default:
        return S.of(context).unknown;
    }
  }

  Widget? setUpItemIcon(String icon) {
    switch (icon) {
      case 'V':
        return SvgPicture.network(brocoliIconUrl);
      case 'G':
        return SvgPicture.network(chickenIconUrl);
      case 'R':
        return SvgPicture.network(cowIconUrl);
      case 'VEG':
        return SvgPicture.network(veganIconUrl);
      case 'A,R':
        return Container(
          width: 40,
          child: Row(
            children: [
              SvgPicture.network(
                alcoholIconUrl,
                width: 20,
              ),
              SvgPicture.network(
                cowIconUrl,
                width: 20,
              ),
            ],
          ),
        );
      case 'S':
        return SvgPicture.network(porkIconUrl);
      case 'F':
        return SvgPicture.network(fischIconUrl);
      case 'G,S':
        return Container(
          width: 40,
          child: Row(
            children: [
              SvgPicture.network(
                chickenIconUrl,
                width: 20,
              ),
              SvgPicture.network(
                porkIconUrl,
                width: 20,
              ),
            ],
          ),
        );

      default:
        return const SizedBox.shrink();
    }
  }

  void essenDialog(SpeisePlanItem item) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Container(
            height: 900,
            width: 700,
            child: Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                Text(
                  item.title!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Image.network(
                  item.foto != null && item.foto!.isNotEmpty
                      ? item.foto!
                      : "https://cdn-icons-png.flaticon.com/512/7669/7669480.png",
                  scale: 3,
                ),
                const SizedBox(
                  height: 40,
                ),
                nutriScoreWidget(item),
                const SizedBox(
                  height: 15,
                ),
                preisWidget(item)
              ],
            ),
          ),
        );
      },
    );
  }

  Widget nutriScoreWidget(SpeisePlanItem item) {
    return Container(
      height: 220,
      width: 500,
      decoration: BoxDecoration(border: Border.all(color: Colors.black)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              Text(
                S.of(context).nutriVals,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
              const Text(
                "Kilojoule",
                style: TextStyle(fontSize: 14),
              ),
              Text(
                S.of(context).kiloCals,
                style: const TextStyle(fontSize: 14),
              ),
              Text(
                S.of(context).fat,
                style: const TextStyle(fontSize: 14),
              ),
              Text(
                S.of(context).saturated,
                style: const TextStyle(fontSize: 14),
              ),
              Text(
                S.of(context).carbs,
                style: const TextStyle(fontSize: 14),
              ),
              Text(
                S.of(context).sugar,
                style: const TextStyle(fontSize: 14),
              ),
              Text(
                S.of(context).fiber,
                style: const TextStyle(fontSize: 14),
              ),
              Text(
                S.of(context).protein,
                style: const TextStyle(fontSize: 14),
              ),
              Text(
                S.of(context).salt,
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
          Column(
            children: [
              Text(
                "${S.of(context).per} Portion",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
              Text(
                "${item.nutritionScores?.kj ?? S.of(context).unknown} kJ",
                style: const TextStyle(fontSize: 14),
              ),
              Text(
                "${item.nutritionScores?.kcal ?? S.of(context).unknown} kcal",
                style: const TextStyle(fontSize: 14),
              ),
              Text(
                "${item.nutritionScores?.fat ?? S.of(context).unknown} g",
                style: const TextStyle(fontSize: 14),
              ),
              Text(
                "${item.nutritionScores?.transfat ?? S.of(context).unknown} g",
                style: const TextStyle(fontSize: 14),
              ),
              Text(
                "${item.nutritionScores?.carbonhydrate ?? S.of(context).unknown} g",
                style: const TextStyle(fontSize: 14),
              ),
              Text(
                "${item.nutritionScores?.sugar ?? S.of(context).unknown} g",
                style: const TextStyle(fontSize: 14),
              ),
              Text(
                "${item.nutritionScores?.ballastoffe ?? S.of(context).unknown} g",
                style: const TextStyle(fontSize: 14),
              ),
              Text(
                "${item.nutritionScores?.protein ?? S.of(context).unknown} g",
                style: const TextStyle(fontSize: 14),
              ),
              Text(
                "${item.nutritionScores?.salz ?? S.of(context).unknown} g",
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              setUpItemIcon(item.kennz_icons ?? "default")!,
              const Text("Nutri-Score"),
              Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(25)),
                  color: setNutriScoreColor(item.nutriscore),
                ),
                height: 50,
                width: 50,
                child: Text(
                  item.nutriscore ?? S.of(context).unknown,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget preisWidget(SpeisePlanItem item) {
    return Container(
      width: 400,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              Text(
                S.of(context).students,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text('${item.preis1 ?? S.of(context).unknown}€')
            ],
          ),
          Column(
            children: [
              Text(
                S.of(context).staff,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text('${item.preis2 ?? S.of(context).unknown}€')
            ],
          ),
          Column(
            children: [
              Text(
                S.of(context).guests,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text('${item.preis3 ?? S.of(context).unknown}€')
            ],
          )
        ],
      ),
    );
  }

  Color setNutriScoreColor(String? score) {
    switch (score) {
      case 'A':
        return Color.fromARGB(200, 3, 90, 6);
      case 'B':
        return const Color.fromARGB(200, 76, 175, 79);
      case 'C':
        return Color.fromARGB(200, 251, 234, 85);
      case 'D':
        return const Color.fromARGB(200, 255, 153, 0);
      case 'E':
        return const Color.fromARGB(200, 244, 67, 54);
      default:
        return const Color.fromARGB(200, 0, 0, 0);
    }
  }

  // Widget setUpFilterListener(String filter, SpeisePlanItem item){

  // }

  // Widget setUpFilterListenerNot(String filter, SpeisePlanItem item){

  // }
}
