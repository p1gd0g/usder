import 'package:get/get.dart';
import 'package:flutter/material.dart';

class FinancialCalculatorController extends GetxController {
  // Text editing controllers
  final rmbRateController = TextEditingController();
  final usdRateController = TextEditingController();
  final exchangeRateController = TextEditingController();
  final principalController = TextEditingController();
  
  // Observable values
  final selectedDate = Rx<DateTime?>(null);
  final rmbProfit = RxDouble(0.0);
  final usdProfit = RxDouble(0.0);
  final totalDays = RxInt(0);
  
  @override
  void onInit() {
    super.onInit();
    // Set default values
    exchangeRateController.text = '7.2';
    principalController.text = '10000';
  }
  
  @override
  void onClose() {
    rmbRateController.dispose();
    usdRateController.dispose();
    exchangeRateController.dispose();
    principalController.dispose();
    super.onClose();
  }
  
  void selectMaturityDate(DateTime date) {
    selectedDate.value = date;
    calculateProfit();
  }
  
  void calculateProfit() {
    try {
      // Parse input values
      final rmbRate = double.tryParse(rmbRateController.text) ?? 0.0;
      final usdRate = double.tryParse(usdRateController.text) ?? 0.0;
      final exchangeRate = double.tryParse(exchangeRateController.text) ?? 0.0;
      final principal = double.tryParse(principalController.text) ?? 0.0;
      final maturityDate = selectedDate.value;
      
      if (maturityDate == null || principal <= 0 || exchangeRate <= 0) {
        rmbProfit.value = 0.0;
        usdProfit.value = 0.0;
        totalDays.value = 0;
        return;
      }
      
      // Calculate days until maturity
      final today = DateTime.now();
      final days = maturityDate.difference(today).inDays;
      totalDays.value = days > 0 ? days : 0;
      
      if (days <= 0) {
        rmbProfit.value = 0.0;
        usdProfit.value = 0.0;
        return;
      }
      
      // Calculate RMB profit: principal * annual rate * days / 365
      rmbProfit.value = principal * (rmbRate / 100) * (days / 365.0);
      
      // Calculate USD profit: (principal / exchange rate) * annual rate * days / 365
      final usdPrincipal = principal / exchangeRate;
      usdProfit.value = usdPrincipal * (usdRate / 100) * (days / 365.0);
      
    } catch (e) {
      rmbProfit.value = 0.0;
      usdProfit.value = 0.0;
      totalDays.value = 0;
    }
  }
}
