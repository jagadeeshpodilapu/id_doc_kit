import 'package:flutter_test/flutter_test.dart';
import 'package:id_doc_kit/id_doc_kit.dart';

void main() {
  test('PAN Basic test', () {
    final result = IdValidator.instance.validate(
      type: IdDocumentType.pan,
      value: 'EWZPP1945L',
    );
    expect(result.isValid, true);
  });
}
