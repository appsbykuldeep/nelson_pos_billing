import 'package:flutter/material.dart';
import 'package:pos_billing/common/abstract_classes/stateful_util.dart';
import 'package:pos_billing/common/data_source/remote_source/remote_source.dart';
import 'package:pos_billing/common/models/sale_reports/itemwise_sale_report.dart';
import 'package:pos_billing/common/singletons/login_ctrl.dart';
import 'package:pos_billing/common/widgets/app_title_wid.dart';
import 'package:pos_billing/common/widgets/data_cell.dart';
import 'package:pos_billing/common/widgets/predefine_daterange_button.dart';
import 'package:pos_billing/core/extensions/datetime_ext.dart';
import 'package:pos_billing/core/extensions/num_ex.dart';
import 'package:pos_billing/core/functions/create_excel_file.dart';

part 'itemwise_daily_sale_util.dart';

class ItemWiseDailySaleScreen extends StatefulWidget {
  const ItemWiseDailySaleScreen({super.key});

  static const String routeName = "/ItemWiseDailySaleScreen";

  @override
  State<ItemWiseDailySaleScreen> createState() =>
      _ItemWiseDailySaleScreenState();
}

class _ItemWiseDailySaleScreenState extends State<ItemWiseDailySaleScreen> {
  late ItemWiseDailySaleUtil util;

  @override
  void initState() {
    util = ItemWiseDailySaleUtil()..onPageInit();
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
    final colors = theme.colorScheme;
    final fixedheadingRowColor = WidgetStateProperty.resolveWith(
      (states) => theme.primaryColor,
    );
    final headStyle = theme.textTheme.labelLarge?.copyWith(
      color: colors.onPrimary,
    );
    final cellStyle = theme.textTheme.labelMedium?.copyWith(
      color: colors.onSurface,
    );

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        title: ValueListenableBuilder(
          valueListenable: util.dateRangeNotifier,
          builder: (context, dateTimeRange, child) {
            return AppTitleWithDateRange(
              title: 'Item Wise Sale',
              dateTimeRange: dateTimeRange,
              onRangeSelection: util.onTapDateRangeChange,
              firstDate: DateTime(2025),
            );
          },
        ),

        actions: [
          IconButton(onPressed: util.onTapExcel, icon: Icon(Icons.download)),
        ],
      ),

      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: PredefineDaterangeButton(
              onTapAny: util.onTapDateRangeChange,
            ),
          ),
          ValueListenableBuilder(
            valueListenable: util.historyNotifier,
            builder: (context, history, child) {
              if (history == null) {
                return SliverToBoxAdapter(
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              if (history.isEmpty) {
                return SliverToBoxAdapter(
                  child: Center(
                    child: Text(
                      "No record found !",

                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                );
              }

              final (
                onlineItemCount,
                onlineItemAmount,
                cashItemCount,
                cashItemAmount,
                totalItemCount,
                totalItemAmount,
              ) = util
                  .getGrandTotal();

              return SliverToBoxAdapter(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    dividerThickness: 2,
                    columnSpacing: 0,
                    border: TableBorder.all(width: 1.0, color: Colors.grey),
                    headingRowColor: fixedheadingRowColor,

                    columns: [
                      DataColumn(
                        label: DataCellWid(
                          "S.No",
                          style: headStyle,

                          alignment: Alignment.center,
                        ),
                        columnWidth: const FixedColumnWidth(80),
                      ),

                      DataColumn(
                        label: DataCellWid(
                          "Date",
                          style: headStyle,

                          alignment: Alignment.center,
                        ),
                        columnWidth: const FixedColumnWidth(150),
                      ),
                      DataColumn(
                        label: DataCellWid(
                          "Name",
                          style: headStyle,
                          alignment: Alignment.center,
                        ),
                        columnWidth: const FixedColumnWidth(200),
                      ),
                      DataColumn(
                        label: DataCellWid(
                          "Name (In English)",
                          style: headStyle,
                          alignment: Alignment.center,
                        ),
                        columnWidth: const FixedColumnWidth(200),
                      ),
                      DataColumn(
                        label: DataCellWid(
                          "Online Qty",
                          style: headStyle,
                          alignment: Alignment.center,
                        ),
                        columnWidth: const FixedColumnWidth(120),
                      ),
                      DataColumn(
                        label: DataCellWid(
                          "Online Amt",
                          style: headStyle,
                          alignment: Alignment.center,
                        ),
                        columnWidth: const FixedColumnWidth(120),
                      ),
                      DataColumn(
                        label: DataCellWid(
                          "Cash Qty",
                          style: headStyle,
                          alignment: Alignment.center,
                        ),
                        columnWidth: const FixedColumnWidth(120),
                      ),
                      DataColumn(
                        label: DataCellWid(
                          "Cash Amt",
                          style: headStyle,
                          alignment: Alignment.center,
                        ),
                        columnWidth: const FixedColumnWidth(120),
                      ),
                      DataColumn(
                        label: DataCellWid(
                          "Total Qty",
                          style: headStyle,
                          alignment: Alignment.center,
                        ),
                        columnWidth: const FixedColumnWidth(120),
                      ),
                      DataColumn(
                        label: DataCellWid(
                          "Total Amt",
                          style: headStyle,
                          alignment: Alignment.center,
                        ),
                        columnWidth: const FixedColumnWidth(120),
                      ),
                    ],
                    rows: [
                      for (var (i, x) in history.indexed)
                        DataRow(
                          color: i.isEven
                              ? WidgetStateProperty.resolveWith(
                                  (states) => Colors.grey.shade200,
                                )
                              : null,
                          cells: [
                            DataCell(DataCellWid("${i + 1}", style: cellStyle)),

                            DataCell(
                              DataCellWid(
                                x.saleDate.dateVibleDate,
                                style: cellStyle,
                              ),
                            ),
                            DataCell(DataCellWid(x.itemName, style: cellStyle)),
                            DataCell(
                              DataCellWid(
                                x.itemNameInEnglish,
                                style: cellStyle,
                              ),
                            ),
                            DataCell(
                              DataCellWid(
                                x.onlineItemCount.thousandText(),
                                style: cellStyle,
                                alignment: Alignment.centerRight,
                              ),
                            ),
                            DataCell(
                              DataCellWid(
                                x.onlineItemAmount.thousandText(),
                                style: cellStyle,
                                alignment: Alignment.centerRight,
                              ),
                            ),
                            DataCell(
                              DataCellWid(
                                x.cashItemCount.thousandText(),
                                style: cellStyle,
                                alignment: Alignment.centerRight,
                              ),
                            ),
                            DataCell(
                              DataCellWid(
                                x.cashItemAmount.thousandText(),
                                style: cellStyle,
                                alignment: Alignment.centerRight,
                              ),
                            ),
                            DataCell(
                              DataCellWid(
                                x.totalItemCount.thousandText(),
                                style: cellStyle,
                                alignment: Alignment.centerRight,
                              ),
                            ),
                            DataCell(
                              DataCellWid(
                                x.totalItemAmount.thousandText(),
                                style: cellStyle,
                                alignment: Alignment.centerRight,
                              ),
                            ),
                          ],
                        ),

                      if (history.isNotEmpty)
                        DataRow(
                          color: fixedheadingRowColor,
                          cells: [
                            ...List.generate(
                              4,
                              (index) => DataCell(SizedBox()),
                            ),

                            DataCell(
                              DataCellWid(
                                onlineItemCount.thousandText(),
                                style: headStyle,
                                alignment: Alignment.centerRight,
                              ),
                            ),
                            DataCell(
                              DataCellWid(
                                onlineItemAmount.thousandText(),
                                style: headStyle,
                                alignment: Alignment.centerRight,
                              ),
                            ),
                            DataCell(
                              DataCellWid(
                                cashItemCount.thousandText(),
                                style: headStyle,
                                alignment: Alignment.centerRight,
                              ),
                            ),
                            DataCell(
                              DataCellWid(
                                cashItemAmount.thousandText(),
                                style: headStyle,
                                alignment: Alignment.centerRight,
                              ),
                            ),
                            DataCell(
                              DataCellWid(
                                totalItemCount.thousandText(),
                                style: headStyle,
                                alignment: Alignment.centerRight,
                              ),
                            ),
                            DataCell(
                              DataCellWid(
                                totalItemAmount.thousandText(),
                                style: headStyle,
                                alignment: Alignment.centerRight,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
