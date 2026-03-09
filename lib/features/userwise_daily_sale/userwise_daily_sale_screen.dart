import 'package:flutter/material.dart';
import 'package:pos_billing/common/abstract_classes/stateful_util.dart';
import 'package:pos_billing/common/data_source/remote_source/remote_source.dart';
import 'package:pos_billing/common/models/sale_reports/user_wise_sale_report.dart';
import 'package:pos_billing/common/singletons/login_ctrl.dart';
import 'package:pos_billing/common/widgets/app_title_wid.dart';
import 'package:pos_billing/common/widgets/data_cell.dart';
import 'package:pos_billing/core/extensions/datetime_ext.dart';
import 'package:pos_billing/core/extensions/num_ex.dart';

part 'userwise_daily_sale_util.dart';

class UserwiseDailySaleScreen extends StatefulWidget {
  const UserwiseDailySaleScreen({super.key});

  static const String routeName = "/UserwiseDailySaleScreen";

  @override
  State<UserwiseDailySaleScreen> createState() =>
      _UserwiseDailySaleScreenState();
}

class _UserwiseDailySaleScreenState extends State<UserwiseDailySaleScreen> {
  late UserwiseDailySaleUtil util;

  @override
  void initState() {
    util = UserwiseDailySaleUtil()..onPageInit();
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
              title: 'User Wise Sale',
              dateTimeRange: dateTimeRange,
              onRangeSelection: util.onTapDateRangeChange,
              firstDate: DateTime(2025),
            );
          },
        ),
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

          final (totalCount, cash, online, totalAmt) = history
              .fold<(int, double, double, double)>(
                (0, 0, 0, 0),
                (p, c) => (
                  p.$1 + c.totalSaleCount,
                  p.$2 + c.cashSaleAmount,
                  p.$2 + c.onlineSaleAmount,
                  p.$2 + c.totalSaleAmount,
                ),
              );

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
                      "Name",
                      style: headStyle,
                      alignment: Alignment.center,
                    ),
                    columnWidth: const FixedColumnWidth(150),
                  ),
                  DataColumn(
                    label: DataCellWid(
                      "Quantity",
                      style: headStyle,
                      alignment: Alignment.center,
                    ),
                    columnWidth: const FixedColumnWidth(120),
                  ),
                  DataColumn(
                    label: DataCellWid(
                      "Cash",
                      style: headStyle,
                      alignment: Alignment.center,
                    ),
                    columnWidth: const FixedColumnWidth(120),
                  ),
                  DataColumn(
                    label: DataCellWid(
                      "Online",
                      style: headStyle,
                      alignment: Alignment.center,
                    ),
                    columnWidth: const FixedColumnWidth(120),
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
                            x.saleDate.dateVibleDate,
                            style: cellStyle,
                          ),
                        ),
                        DataCell(DataCellWid(x.userFullName, style: cellStyle)),
                        DataCell(
                          DataCellWid(
                            x.totalSaleCount.thousandText(),
                            style: cellStyle,
                            alignment: Alignment.centerRight,
                          ),
                        ),
                        DataCell(
                          DataCellWid(
                            x.cashSaleAmount.thousandText(),
                            style: cellStyle,
                            alignment: Alignment.centerRight,
                          ),
                        ),
                        DataCell(
                          DataCellWid(
                            x.onlineSaleAmount.thousandText(),
                            style: cellStyle,
                            alignment: Alignment.centerRight,
                          ),
                        ),
                        DataCell(
                          DataCellWid(
                            x.totalSaleAmount.thousandText(),
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
                        ...List.generate(3, (index) => DataCell(SizedBox())),

                        DataCell(
                          DataCellWid(
                            totalCount.thousandText(),
                            style: headStyle,
                            alignment: Alignment.centerRight,
                          ),
                        ),
                        DataCell(
                          DataCellWid(
                            cash.thousandText(),
                            style: headStyle,
                            alignment: Alignment.centerRight,
                          ),
                        ),
                        DataCell(
                          DataCellWid(
                            online.thousandText(),
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
