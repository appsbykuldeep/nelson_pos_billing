import 'package:flutter/material.dart';
import 'package:pos_billing/common/abstract_classes/stateful_util.dart';
import 'package:pos_billing/common/classes/socketio_handler.dart';
import 'package:pos_billing/common/data_source/remote_source/remote_source.dart';
import 'package:pos_billing/common/models/sale/receipt_info.dart';
import 'package:pos_billing/common/singletons/login_ctrl.dart';
import 'package:pos_billing/common/widgets/app_title_wid.dart';
import 'package:pos_billing/common/widgets/data_cell.dart';
import 'package:pos_billing/core/extensions/datetime_ext.dart';
import 'package:pos_billing/core/extensions/num_ex.dart';
import 'package:pos_billing/core/extensions/string_ext.dart';
import 'package:pos_billing/core/functions/create_excel_file.dart';

part 'sitewise_history_util.dart';

class SitewiseHistoryScreen extends StatefulWidget {
  const SitewiseHistoryScreen({super.key});

  static const String routeName = "/SitewiseHistory";

  @override
  State<SitewiseHistoryScreen> createState() => _SitewiseHistoryScreenState();
}

class _SitewiseHistoryScreenState extends State<SitewiseHistoryScreen> {
  late SitewiseHistoryUtil util;

  @override
  void initState() {
    util = SitewiseHistoryUtil()..onPageInit();
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
              title: 'Sale History',
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

      body: ValueListenableBuilder(
        valueListenable: util.historyNotifier,
        builder: (context, history, child) {
          if (history == null) {
            return Center(child: CircularProgressIndicator());
          }
          if (history.isEmpty) {
            return Center(
              child: Text(
                "No record found !",

                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            );
          }

          final (totalCount, totalAmt) = history.fold<(int, double)>((
            0,
            0,
          ), (p, c) => (p.$1 + c.totalItems, p.$2 + c.totalAmount));

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(5, 10, 5, 60),
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
                      "Operator",
                      style: headStyle,
                      alignment: Alignment.center,
                    ),
                    columnWidth: const FixedColumnWidth(150),
                  ),
                  DataColumn(
                    label: DataCellWid(
                      "Bill No",
                      style: headStyle,
                      alignment: Alignment.center,
                    ),
                    columnWidth: const FixedColumnWidth(100),
                  ),
                  DataColumn(
                    label: DataCellWid(
                      "Quantity",
                      style: headStyle,
                      alignment: Alignment.center,
                    ),
                    columnWidth: const FixedColumnWidth(100),
                  ),
                  DataColumn(
                    label: DataCellWid(
                      "Amount",
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
                            x.saleOn?.dateVibleDate ?? "-",
                            style: cellStyle,
                          ),
                        ),
                        DataCell(
                          DataCellWid(x.saleByFullName, style: cellStyle),
                        ),
                        DataCell(
                          DataCellWid(
                            x.showSaleNumber,
                            style: cellStyle,
                            alignment: Alignment.centerRight,
                          ),
                        ),
                        DataCell(
                          DataCellWid(
                            x.totalItems.thousandText(),
                            style: cellStyle,
                            alignment: Alignment.centerRight,
                          ),
                        ),
                        DataCell(
                          DataCellWid(
                            x.totalAmount.thousandText(),
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
                        ...List.generate(4, (index) => DataCell(SizedBox())),

                        DataCell(
                          DataCellWid(
                            totalCount.thousandText(),
                            style: headStyle,
                            alignment: Alignment.centerRight,
                          ),
                        ),
                        DataCell(
                          DataCellWid(
                            totalAmt.thousandText(),
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
    );
  }
}
