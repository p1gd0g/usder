import 'package:flutter_test/flutter_test.dart';
import 'package:myapp/controllers/financial_calculator_controller.dart';
import 'package:get/get.dart';

void main() {
  group('FinancialCalculatorController Tests', () {
    late FinancialCalculatorController controller;

    setUp(() {
      controller = FinancialCalculatorController();
    });

    tearDown(() {
      controller.dispose();
    });

    test('Initial values are set correctly', () {
      expect(controller.exchangeRateController.text, '7.2');
      expect(controller.principalController.text, '10000');
      expect(controller.rmbProfit.value, 0.0);
      expect(controller.usdProfit.value, 0.0);
    });

    test('Calculate RMB profit correctly', () {
      // Set input values
      controller.principalController.text = '10000';
      controller.rmbRateController.text = '3.5';
      controller.usdRateController.text = '4.2';
      controller.exchangeRateController.text = '7.2';
      
      // Set maturity date to 365 days from now
      final futureDate = DateTime.now().add(const Duration(days: 365));
      controller.selectMaturityDate(futureDate);
      
      // Expected RMB profit: 10000 * 0.035 * (365/365) = 350
      expect(controller.rmbProfit.value, closeTo(350, 1.0));
      expect(controller.totalDays.value, 365);
    });

    test('Calculate USD profit correctly', () {
      // Set input values
      controller.principalController.text = '10000';
      controller.rmbRateController.text = '3.5';
      controller.usdRateController.text = '4.2';
      controller.exchangeRateController.text = '7.2';
      
      // Set maturity date to 365 days from now
      final futureDate = DateTime.now().add(const Duration(days: 365));
      controller.selectMaturityDate(futureDate);
      
      // Expected USD profit: (10000 / 7.2) * 0.042 * (365/365)
      // = 1388.89 * 0.042 = 58.33
      expect(controller.usdProfit.value, closeTo(58.33, 1.0));
    });

    test('Calculate profit for 180 days', () {
      // Set input values
      controller.principalController.text = '20000';
      controller.rmbRateController.text = '4.0';
      controller.usdRateController.text = '5.0';
      controller.exchangeRateController.text = '7.0';
      
      // Set maturity date to 180 days from now
      final futureDate = DateTime.now().add(const Duration(days: 180));
      controller.selectMaturityDate(futureDate);
      
      // Expected RMB profit: 20000 * 0.04 * (180/365) = 394.52
      expect(controller.rmbProfit.value, closeTo(394.52, 1.0));
      
      // Expected USD profit: (20000 / 7.0) * 0.05 * (180/365)
      // = 2857.14 * 0.05 * 0.493 = 70.41
      expect(controller.usdProfit.value, closeTo(70.41, 1.0));
      
      expect(controller.totalDays.value, 180);
    });

    test('Handle invalid inputs gracefully', () {
      // Set invalid values
      controller.principalController.text = 'invalid';
      controller.rmbRateController.text = 'abc';
      
      controller.calculateProfit();
      
      // Should default to 0
      expect(controller.rmbProfit.value, 0.0);
      expect(controller.usdProfit.value, 0.0);
    });

    test('Handle missing date', () {
      // Set valid input values but no date
      controller.principalController.text = '10000';
      controller.rmbRateController.text = '3.5';
      controller.usdRateController.text = '4.2';
      controller.exchangeRateController.text = '7.2';
      
      controller.calculateProfit();
      
      // Should return 0 when no date is selected
      expect(controller.rmbProfit.value, 0.0);
      expect(controller.usdProfit.value, 0.0);
      expect(controller.totalDays.value, 0);
    });

    test('Handle past date', () {
      // Set input values
      controller.principalController.text = '10000';
      controller.rmbRateController.text = '3.5';
      controller.usdRateController.text = '4.2';
      controller.exchangeRateController.text = '7.2';
      
      // Set date in the past
      final pastDate = DateTime.now().subtract(const Duration(days: 10));
      controller.selectMaturityDate(pastDate);
      
      // Should return 0 for past dates
      expect(controller.rmbProfit.value, 0.0);
      expect(controller.usdProfit.value, 0.0);
      expect(controller.totalDays.value, 0);
    });
  });
}
