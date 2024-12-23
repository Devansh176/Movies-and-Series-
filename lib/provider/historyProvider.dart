import 'package:cineflix/database/dbConnection.dart';
import 'package:flutter/cupertino.dart';

class HistoryProvider extends ChangeNotifier {
  final DBConnection dbConnection;
  HistoryProvider({required this.dbConnection});

  List<Map<String, dynamic>> _data = [];
  List<Map<String, dynamic>> getData() => _data;

  Future<void> fetchDataFromDb() async {
    final dbData = await DBConnection.getInstance.getAllTransactions();
    print("Fetched data: $dbData");
    _data = dbData;
    notifyListeners();
  }

  Future<void> addData({
    required String title,
    required String cost,
    required String date,
    required String time,
    required String status,
  }) async {
    final success = await DBConnection.getInstance.addTransaction(
      title: title,
      cost: cost,
      date: date,
      time: time,
      status: status,
    );
    if (success) {
      await fetchDataFromDb();
      notifyListeners();
    }
  }

  // void updateData(Map<String, dynamic> updatedData, int index) {
  //   _data[index] = updatedData;
  //   notifyListeners();
  // }

  Future<void> getInitialHistory() async {
    _data = await dbConnection.getAllTransactions();
    print("Fetched History : $_data");
    notifyListeners();
  }

  // Future<void> deleteData(int id) async {
  //   await DBConnection.getInstance.deleteTransaction(id);
  //   await fetchDataFromDb();
  //   notifyListeners();
  // }
}