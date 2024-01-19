import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:public_display_application/models/speiseplan_item.dart';

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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          dateWidget(),
          Expanded(
              child: ListView.builder(
            itemCount: widget.data[timestamps[day]]!.length,
            itemBuilder: (context, index) {
              SpeisePlanItem item = widget.data[timestamps[day]]![index];
              return ListTile(
                leading: setUpItemIcon(item.kennz_icons!),
                onTap: () => essenDialog(item),
                title: Text(item.title!),
                trailing: Container(
                  width: 100,
                  child: Row(
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
                ),
              );
            },
          ))
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
          ),
        ),
        Text(
          "${weekdayString(date.weekday)}, ${date.day}.${date.month}.${date.year}",
        ),
        IconButton(
          onPressed: () => setState(() {
            if (day < 6) {
              day++;
              print(day);
            }
          }),
          icon: const Icon(
            Icons.arrow_right,
          ),
        ),
      ],
    );
  }

  String weekdayString(int day) {
    switch (day) {
      case 1:
        return "Montag";
      case 2:
        return "Dienstag";
      case 3:
        return "Mittwoch";
      case 4:
        return "Donnerstag";
      case 5:
        return "Freitag";
      case 6:
        return "Samstag";
      case 7:
        return "Sonntag";
      default:
        return "Unknown";
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
          const Column(
            children: [
              Text(
                "Nähr­werte",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
              Text(
                "Kilojoule",
                style: TextStyle(fontSize: 14),
              ),
              Text(
                "Kilokalorien",
                style: TextStyle(fontSize: 14),
              ),
              Text(
                "Fett",
                style: TextStyle(fontSize: 14),
              ),
              Text(
                "gesättigt",
                style: TextStyle(fontSize: 14),
              ),
              Text(
                "Kohlen­hydrate",
                style: TextStyle(fontSize: 14),
              ),
              Text(
                "Zucker",
                style: TextStyle(fontSize: 14),
              ),
              Text(
                "Ballast­stoffe",
                style: TextStyle(fontSize: 14),
              ),
              Text(
                "Eiweiß",
                style: TextStyle(fontSize: 14),
              ),
              Text(
                "Salz",
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
          Column(
            children: [
              const Text(
                "Pro Portion",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
              Text(
                "${item.nutritionScores?.kj ?? "Unknown"} kJ",
                style: const TextStyle(fontSize: 14),
              ),
              Text(
                "${item.nutritionScores?.kcal ?? "Unknown"} kcal",
                style: const TextStyle(fontSize: 14),
              ),
              Text(
                "${item.nutritionScores?.fat ?? "Unknown"} g",
                style: const TextStyle(fontSize: 14),
              ),
              Text(
                "${item.nutritionScores?.transfat ?? "Unknown"} g",
                style: const TextStyle(fontSize: 14),
              ),
              Text(
                "${item.nutritionScores?.carbonhydrate ?? "Unknown"} g",
                style: const TextStyle(fontSize: 14),
              ),
              Text(
                "${item.nutritionScores?.sugar ?? "Unknown"} g",
                style: const TextStyle(fontSize: 14),
              ),
              Text(
                "${item.nutritionScores?.ballastoffe ?? "Unknown"} g",
                style: const TextStyle(fontSize: 14),
              ),
              Text(
                "${item.nutritionScores?.protein ?? "Unkown"} g",
                style: const TextStyle(fontSize: 14),
              ),
              Text(
                "${item.nutritionScores?.salz ?? "Unknown"} g",
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
                  item.nutriscore ?? "Unknown",
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
              const Text(
                "Studenten",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text('${item.preis1 ?? "Unknown"}€')
            ],
          ),
          Column(
            children: [
              const Text(
                "Bedienende",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text('${item.preis2 ?? "Unknown"}€')
            ],
          ),
          Column(
            children: [
              const Text(
                "Gäste",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text('${item.preis3 ?? "Unknown"}€')
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
}
