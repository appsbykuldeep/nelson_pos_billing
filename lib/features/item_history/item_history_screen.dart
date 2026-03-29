import 'package:flutter/material.dart';
import 'package:pos_billing/common/abstract_classes/stateful_util.dart';
import 'package:pos_billing/common/data_source/remote_source/remote_source.dart';
import 'package:pos_billing/common/dialogues/confirmation.dart';
import 'package:pos_billing/common/dialogues/show_generaloption_sheet.dart';
import 'package:pos_billing/common/dialogues/show_loading.dart';
import 'package:pos_billing/common/models/item/item_info.dart';
import 'package:pos_billing/common/singletons/app.dart';
import 'package:pos_billing/config/enums/app_general_options.dart';
import 'package:pos_billing/core/extensions/num_ex.dart';
import 'package:pos_billing/core/extensions/string_ext.dart';
import 'package:pos_billing/features/addupdate_item/add_update_item_screen.dart';

part 'item_history_util.dart';

class ItemHistoryScreen extends StatefulWidget {
  const ItemHistoryScreen({super.key});

  static const String routeName = "/ItemHistoryScreen";

  @override
  State<ItemHistoryScreen> createState() => _ItemHistoryScreenState();
}

class _ItemHistoryScreenState extends State<ItemHistoryScreen> {
  late ItemHistoryUtil util;

  @override
  void initState() {
    util = ItemHistoryUtil(context: context)..onPageInit();
    super.initState();
  }

  @override
  void dispose() {
    util.onPageClose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return Scaffold(
      appBar: AppBar(title: Text("Items")),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: util.onAddUpdateitem,
        label: Text("Item"),
        icon: Icon(Icons.add),
      ),
      body: ValueListenableBuilder(
        valueListenable: util.showItems,
        builder: (context, showItems, child) {
          if (showItems == null) {
            return Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            itemCount: showItems.length,
            shrinkWrap: true,
            padding: EdgeInsets.fromLTRB(0, 0, 0, 100),

            itemBuilder: (context, index) {
              final data = showItems[index];
              return Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: index.isEven ? Colors.grey.shade200 : null,
                ),
                child: Row(
                  spacing: 10,
                  children: [
                    Expanded(
                      child: Text.rich(
                        TextSpan(
                          text: data.itemName,
                          children: [
                            if (data.itemNameInEnglish.isNotEmpty) ...[
                              TextSpan(text: "\n"),
                              TextSpan(
                                text: data.itemNameInEnglish,

                                style: textTheme.bodyMedium,
                              ),
                            ],
                          ],
                        ),
                        style: textTheme.titleMedium,
                      ),
                    ),

                    Text(
                      "Rs.${data.itemRate.thousandText()}",
                      style: textTheme.titleMedium,
                    ),
                    InkWell(
                      onTap: () => util.deleteItem(data),
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.red.shade100,
                        child: Icon(Icons.delete, color: Colors.red, size: 24),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
