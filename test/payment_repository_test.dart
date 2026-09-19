import 'package:flutter_test/flutter_test.dart';

import 'package:foodbook/data/repositories/payment_repository.dart';

/// Helper local: replica la codificacion interna sin tocar DB.
String _encode(String? note, String? method) {
  if (method == null || method.isEmpty) return note ?? '';
  final n = note ?? '';
  return '${PaymentRepository.methodPrefix}$method${PaymentRepository.methodSuffix}$n';
}

void main() {
  group('PaymentRepository decode', () {
    test('decode sin prefijo retorna (null, nota completa)', () {
      final r = PaymentRepository.decode('Pago del martes');
      expect(r.$1, isNull);
      expect(r.$2, 'Pago del martes');
    });

    test('decode con prefijo retorna tupla (metodo, nota)', () {
      final r = PaymentRepository.decode('[method:Yape]Pago semanal');
      expect(r.$1, 'Yape');
      expect(r.$2, 'Pago semanal');
    });

    test('decode de null retorna (null, null)', () {
      final r = PaymentRepository.decode(null);
      expect(r.$1, isNull);
      expect(r.$2, isNull);
    });

    test('decode de vacio retorna (null, null)', () {
      final r = PaymentRepository.decode('');
      expect(r.$1, isNull);
      expect(r.$2, isNull);
    });

    test('decode sin sufijo retorna (null, texto completo)', () {
      final r = PaymentRepository.decode('[method:Yape');
      expect(r.$1, isNull);
      expect(r.$2, '[method:Yape');
    });

    test('decode con nota vacia devuelve metodo + null', () {
      final r = PaymentRepository.decode('[method:Efectivo]');
      expect(r.$1, 'Efectivo');
      expect(r.$2, isNull);
    });
  });

  group('PaymentRepository encode (helper local)', () {
    test('con metodo agrega prefijo [method:nombre]', () {
      expect(_encode('Pago', 'Yape'), '[method:Yape]Pago');
    });

    test('sin metodo devuelve nota tal cual', () {
      expect(_encode('Solo nota', null), 'Solo nota');
    });

    test('sin metodo y sin nota devuelve vacio', () {
      expect(_encode(null, null), '');
    });

    test('con nota vacia devuelve solo prefijo', () {
      expect(_encode('', 'Efectivo'), '[method:Efectivo]');
    });

    test('roundtrip con metodo preserva datos', () {
      const nota = 'Pago completo';
      const metodo = 'Yape';
      final enc = _encode(nota, metodo);
      final dec = PaymentRepository.decode(enc);
      expect(dec.$1, metodo);
      expect(dec.$2, nota);
    });

    test('roundtrip sin metodo preserva nota', () {
      const nota = 'Solo transferencia';
      final enc = _encode(nota, null);
      final dec = PaymentRepository.decode(enc);
      expect(dec.$1, isNull);
      expect(dec.$2, nota);
    });

    test('metodos diferentes se decodifican independientemente', () {
      expect(PaymentRepository.decode('[method:Yape]x').$1, 'Yape');
      expect(PaymentRepository.decode('[method:Plin]x').$1, 'Plin');
      expect(PaymentRepository.decode('[method:Efectivo]x').$1, 'Efectivo');
      expect(PaymentRepository.decode('[method:Transferencia]x').$1,
          'Transferencia');
    });
  });

  group('constantes publicas', () {
    test('methodPrefix es [method:', () {
      expect(PaymentRepository.methodPrefix, '[method:');
    });

    test('methodSuffix es ]', () {
      expect(PaymentRepository.methodSuffix, ']');
    });
  });
}
