import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:public_display_application/models/speiseplan_item.dart';

class MensaContent extends StatefulWidget {
  List<SpeisePlanItem> data;
  MensaContent({required this.data});
  @override
  State<StatefulWidget> createState() {
    return _MensaContentState();
  }
}

class _MensaContentState extends State<MensaContent> {
  String? selectedCategory;
  TextEditingController searchController = TextEditingController();
  List<SpeisePlanItem> filteredData = [];

  @override
  void initState() {
    super.initState();
    filteredData = widget.data;
  }

  void filterData() {
    setState(() {
      filteredData = widget.data
          .where((item) =>
              (selectedCategory == null || item.category == selectedCategory) &&
              (searchController.text.isEmpty ||
                  item.title!
                      .toLowerCase()
                      .contains(searchController.text.toLowerCase())))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                DropdownButton<String>(
                  hint: Text('Select Category'),
                  value: selectedCategory,
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value;
                    });
                    filterData();
                  },
                  items:
                      ['vegan'].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: searchController,
                    onChanged: (value) {
                      filterData();
                    },
                    decoration: const InputDecoration(
                      labelText: 'Search',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: widget.data.isNotEmpty
                ? ListView.builder(
                    itemCount: filteredData.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(filteredData[index].title!),
                        subtitle: Text(
                            filteredData[index].description ?? "description"),
                      );
                    },
                  )
                : const Text(
                    'Zur Zeit kein Speiseplan verfügbar.',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
