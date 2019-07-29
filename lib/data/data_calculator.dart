import '../core/bill.dart';
import '../core/settings.dart';

double calculateTotalIncomes(List<Bill> bills) =>
    Bill.getBillsTotalAmount(Bill.filterBillsByType(bills, Bill.income));

double calculateTotalOutcomes(List<Bill> bills) {
  return Bill.getBillsTotalAmount(
    Bill.filterBillsByType(bills, Bill.outcome),
  );
}

double calculateDailyLimit(List<Bill> bills, Settings settings) {
  return settings.balance +
      calculateTotalIncomes(bills) -
      calculateTotalOutcomes(bills) -
      settings.desiredMonthlySaveUps;
}

double calculateCash(List<Bill> bills, Settings settings) {
  return calculateTotalIncomes(bills) - calculateTotalOutcomes(bills);
}

double calculateBalanceBasedCash(List<Bill> bills, Settings settings) {
  return settings.balance +
      calculateTotalIncomes(bills) -
      calculateTotalOutcomes(bills);
}

double calculateCreditRate(List<Bill> bills, Settings settings) {
  return calculateCash(bills, settings) -
      settings.desiredMonthlySaveUps;
}
