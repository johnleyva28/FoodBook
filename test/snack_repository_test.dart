import 'package:flutter_test/flutter_test.dart';

import 'package:foodbook/data/repositories/snack_repository.dart';

/// Helper local: replica la codificacion interna sin tocar DB.
String _encode(String? description, String? cat) {
  if (cat == null || cat.isEmpty) return description ?? '';
  final d = description ?? '';
  return '${SnackRepository.categoryPrefix}$cat${SnackRepository.categorySuffix}$d';
}

void main() {
  group('SnackRepository decode', () {
    test('decode sin prefijo retorna (null, descripcion)', () {
      final r = SnackRepository.decode('Agua mineral');
      expect(r.$1, isNull);
      expect(r.$2, 'Agua mineral');
    });

    test('decode con prefijo retorna tupla (categoria, descripcion)', () {
      final r = SnackRepository.decode('[cat:Panadería]Croissant');
      expect(r.$1, 'Panadería');
      expect(r.$2, 'Croissant');
    });

    test('decode de null retorna (null, null)', () {
      final r = SnackRepository.decode(null);
      expect(r.$1, isNull);
      expect(r.$2, isNull);
    });

    test('decode de vacio retorna (null, null)', () {
      final r = SnackRepository.decode('');
      expect(r.$1, isNull);
      expect(r.$2, isNull);
    });

    test('decode con categoria vacia devuelve tupla con cat vacio', () {
      final r = SnackRepository.decode('[cat:]texto');
      expect(r.$1, '');
      expect(r.$2, 'texto');
    });

    test('decode con descripcion vacia devuelve categoria + null', () {
      final r = SnackRepository.decode('[cat:Fruta]');
      expect(r.$1, 'Fruta');
      expect(r.$2, isNull);
    });
  });

  group('SnackRepository encode (helper local)', () {
    test('con categoria agrega prefijo', () {
      expect(_encode('Croissant', 'Panadería'), '[cat:Panadería]Croissant');
    });

    test('sin categoria devuelve descripcion tal cual', () {
      expect(_encode('Café con leche', null), 'Café con leche');
    });

    test('sin categoria y sin descripcion devuelve vacio', () {
      expect(_encode(null, null), '');
    });

    test('con descripcion vacia devuelve solo prefijo', () {
      expect(_encode('', 'Fruta'), '[cat:Fruta]');
    });

    test('roundtrip encode+decode preserva datos', () {
      const desc = 'Café con leche';
      const cat = 'Café';
      final enc = _encode(desc, cat);
      final dec = SnackRepository.decode(enc);
      expect(dec.$1, cat);
      expect(dec.$2, desc);
    });

    test('roundtrip sin categoria preserva descripcion', () {
      const desc = 'Agua mineral';
      final enc = _encode(desc, null);
      final dec = SnackRepository.decode(enc);
      expect(dec.$1, isNull);
      expect(dec.$2, desc);
    });
  });

  group('constantes publicas', () {
    test('categoryPrefix es [cat:', () {
      expect(SnackRepository.categoryPrefix, '[cat:');
    });

    test('categorySuffix es ]', () {
      expect(SnackRepository.categorySuffix, ']');
    });
  });
}
