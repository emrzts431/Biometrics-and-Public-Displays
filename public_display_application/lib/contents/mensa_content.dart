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
  int day = 0;
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
        return null;
    }
  }
}
