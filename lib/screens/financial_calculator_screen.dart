import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/financial_calculator_controller.dart';

class FinancialCalculatorScreen extends StatelessWidget {
  const FinancialCalculatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FinancialCalculatorController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('理财收益计算器'),
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Principal Amount Input
            _buildInputCard(
              title: '本金金额 (CNY)',
              controller: controller.principalController,
              hint: '请输入本金金额',
              icon: Icons.account_balance_wallet,
              onChanged: (_) => controller.calculateProfit(),
            ),
            const SizedBox(height: 16),

            // RMB Rate Input
            _buildInputCard(
              title: '人民币理财年化利率 (%)',
              controller: controller.rmbRateController,
              hint: '例如: 3.5',
              icon: Icons.trending_up,
              onChanged: (_) => controller.calculateProfit(),
            ),
            const SizedBox(height: 16),

            // USD Rate Input
            _buildInputCard(
              title: '美元理财年化利率 (%)',
              controller: controller.usdRateController,
              hint: '例如: 4.2',
              icon: Icons.trending_up,
              onChanged: (_) => controller.calculateProfit(),
            ),
            const SizedBox(height: 16),

            // Exchange Rate Input
            _buildInputCard(
              title: '人民币/美元汇率',
              controller: controller.exchangeRateController,
              hint: '例如: 7.2',
              icon: Icons.currency_exchange,
              onChanged: (_) => controller.calculateProfit(),
            ),
            const SizedBox(height: 16),

            // Maturity Date Picker
            _buildDatePickerCard(controller),
            const SizedBox(height: 24),

            // Calculate Button
            ElevatedButton.icon(
              onPressed: () => controller.calculateProfit(),
              icon: const Icon(Icons.calculate),
              label: const Text('计算收益', style: TextStyle(fontSize: 18)),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Results Section
            _buildResultsSection(controller),
          ],
        ),
      ),
    );
  }

  Widget _buildInputCard({
    required String title,
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required Function(String) onChanged,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
              ],
              decoration: InputDecoration(
                hintText: hint,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.grey[50],
              ),
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDatePickerCard(FinancialCalculatorController controller) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.calendar_today, size: 20, color: Colors.blue),
                SizedBox(width: 8),
                Text(
                  '理财到期日',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Obx(() {
              final selectedDate = controller.selectedDate.value;
              return InkWell(
                onTap: () async {
                  final now = DateTime.now();
                  final picked = await showDatePicker(
                    context: Get.context!,
                    initialDate: selectedDate ?? now.add(const Duration(days: 365)),
                    firstDate: now,
                    lastDate: now.add(const Duration(days: 3650)),
                  );
                  if (picked != null) {
                    controller.selectMaturityDate(picked);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey[50],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        selectedDate != null
                            ? DateFormat('yyyy-MM-dd').format(selectedDate)
                            : '请选择到期日期',
                        style: TextStyle(
                          fontSize: 16,
                          color: selectedDate != null
                              ? Colors.black87
                              : Colors.grey,
                        ),
                      ),
                      const Icon(Icons.arrow_drop_down, color: Colors.grey),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsSection(FinancialCalculatorController controller) {
    return Obx(() {
      final rmbProfit = controller.rmbProfit.value;
      final usdProfit = controller.usdProfit.value;
      final days = controller.totalDays.value;

      if (days == 0) {
        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: const Padding(
            padding: EdgeInsets.all(24.0),
            child: Center(
              child: Text(
                '请输入完整信息后点击计算',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            '收益结果',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          
          // Investment Duration
          Card(
            color: Colors.blue[50],
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.access_time, color: Colors.blue),
                  const SizedBox(width: 8),
                  Text(
                    '理财期限: $days 天',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // RMB Profit Card
          Card(
            color: Colors.green[50],
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.attach_money,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        '人民币理财收益',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '¥ ${rmbProfit.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // USD Profit Card
          Card(
            color: Colors.orange[50],
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.attach_money,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        '美元理财收益',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '\$ ${usdProfit.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }
}
