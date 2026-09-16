import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../data/database/app_database.dart';
import '../../../data/repositories/payment_repository.dart';
import '../../../data/repositories/snack_repository.dart';

/// Tipo de resultado de búsqueda.
enum SearchKind { snack, payment }

class SearchHit {
  final SearchKind kind;
  final int id;
  final String date;
  final String title;
  final String? subtitle;
  final double amount;

  const SearchHit({
    required this.kind,
    required this.id,
    required this.date,
    required this.title,
    this.subtitle,
    required this.amount,
  });
}

/// ViewModel de búsqueda global.
class SearchViewModel extends ChangeNotifier {
  final SnackRepository _snackRepo;
  final PaymentRepository _paymentRepo;

  String query = '';
  List<SearchHit> hits = [];
  bool loading = false;

  StreamSubscription<List<SnackEntry>>? _snacksSub;
  StreamSubscription<List<Payment>>? _paymentsSub;

  List<SnackEntry> _snacks = [];
  List<Payment> _payments = [];

  SearchViewModel(this._snackRepo, this._paymentRepo);

  Future<void> init() async {
    _snacksSub = _snackRepo.watchAll().listen((value) {
      _snacks = value;
      _recompute();
    });
    _paymentsSub = _paymentRepo.watchAll().listen((value) {
      _payments = value;
      _recompute();
    });
  }

  void setQuery(String q) {
    query = q;
    _recompute();
  }

  void _recompute() {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) {
      hits = [];
      notifyListeners();
      return;
    }
    final result = <SearchHit>[];

    for (final s in _snacks) {
      final decoded = SnackRepository.decode(s.description);
      final title = decoded.$2 ?? 'Bocadillo';
      final cat = decoded.$1;
      if (title.toLowerCase().contains(q) ||
          (cat != null && cat.toLowerCase().contains(q)) ||
          s.date.contains(q) ||
          s.price.toStringAsFixed(2).contains(q)) {
        result.add(SearchHit(
          kind: SearchKind.snack,
          id: s.id,
          date: s.date,
          title: title,
          subtitle: cat,
          amount: s.price,
        ));
      }
    }
    for (final p in _payments) {
      final decoded = PaymentRepository.decode(p.note);
      final title = decoded.$1 ?? 'Pago';
      final note = decoded.$2;
      if (title.toLowerCase().contains(q) ||
          (note != null && note.toLowerCase().contains(q)) ||
          p.date.contains(q) ||
          p.amount.toStringAsFixed(2).contains(q)) {
        result.add(SearchHit(
          kind: SearchKind.payment,
          id: p.id,
          date: p.date,
          title: title,
          subtitle: note,
          amount: p.amount,
        ));
      }
    }

    hits = result;
    notifyListeners();
  }

  @override
  void dispose() {
    _snacksSub?.cancel();
    _paymentsSub?.cancel();
    super.dispose();
  }
}
