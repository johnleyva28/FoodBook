import 'package:flutter/foundation.dart';

import '../../../data/app_data_streams.dart';
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
///
/// Lee del `AppDataStreams` global para reactividad en vivo.
class SearchViewModel extends ChangeNotifier {
  final AppDataStreams _streams;
  // ignore: unused_field
  final SnackRepository _snackRepo;
  // ignore: unused_field
  final PaymentRepository _paymentRepo;

  SearchViewModel(this._streams, this._snackRepo, this._paymentRepo) {
    _streams.addListener(_onChange);
  }

  String query = '';
  bool loading = false;

  void _onChange() => notifyListeners();

  @override
  void dispose() {
    _streams.removeListener(_onChange);
    super.dispose();
  }

  void setQuery(String q) {
    query = q;
    _recompute();
  }

  List<SearchHit> get hits {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return const [];
    final result = <SearchHit>[];

    for (final s in _streams.snacks) {
      final decoded = SnackRepository.decode(s.description);
      final title = decoded.$2 ?? 'Bocadillo';
      final cat = decoded.$1;
      if (title.toLowerCase().contains(q) ||
          (cat != null && cat.toLowerCase().contains(q)) ||
          s.date.contains(q) ||
          s.price.toStringAsFixed(2).contains(q)) {
        result.add(
          SearchHit(
            kind: SearchKind.snack,
            id: s.id,
            date: s.date,
            title: title,
            subtitle: cat,
            amount: s.price,
          ),
        );
      }
    }
    for (final p in _streams.payments) {
      final decoded = PaymentRepository.decode(p.note);
      final title = decoded.$1 ?? 'Pago';
      final note = decoded.$2;
      if (title.toLowerCase().contains(q) ||
          (note != null && note.toLowerCase().contains(q)) ||
          p.date.contains(q) ||
          p.amount.toStringAsFixed(2).contains(q)) {
        result.add(
          SearchHit(
            kind: SearchKind.payment,
            id: p.id,
            date: p.date,
            title: title,
            subtitle: note,
            amount: p.amount,
          ),
        );
      }
    }
    return result;
  }

  void _recompute() => notifyListeners();
}
