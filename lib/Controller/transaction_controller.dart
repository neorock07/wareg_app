import 'package:get/get.dart';
import '../Services/transaction_service.dart';

class TransactionController extends GetxController {
  var transactions = <dynamic>[].obs;
  var isLoading = true.obs;
  final TransactionService _transactionService = TransactionService();

  Future<void> fetchTransactions() async {
    try {
      isLoading(true);
      var fetchedTransactions = await _transactionService.fetchTransactions();
      transactions.value = fetchedTransactions;
    } catch (e) {
      print('Failed to fetch transactions: $e');
    } finally {
      isLoading(false);
    }
  }
}
