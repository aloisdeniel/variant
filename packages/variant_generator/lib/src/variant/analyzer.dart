import 'package:analyzer/dart/element/element.dart';
import 'package:source_gen/source_gen.dart';
import 'package:variant/variant.dart';

import 'definitions.dart';

List<VariantDefinition> analyzeVariants(LibraryReader library) {
  final flagEnums = library
      .annotatedWith(TypeChecker.fromRuntime(VariantFlag))
      .map((element) => element.element)
      .whereType<EnumElement>()
      .toList();

  final result = <VariantDefinition>[];

  var index = 1;
  for (var flagEnum in flagEnums) {
    final values = <VariantValueDefinition>[];
    final constEnum = flagEnum.children.whereType<FieldElement>().toList();
    for (var i = 0; i < constEnum.length; i++) {
      final value = constEnum[i];
      if (value.name != 'values') {
        final flag = () {
          final bitcode = '1${'0' * index}';
          final flag = int.parse(bitcode, radix: 2);
          index++;
          if (index > 64) {
            throw Exception('You can\'t have more than 64 variant values');
          }
          return flag;
        }();
        values.add(
            VariantValueDefinition(flagEnum.displayName, value.name, flag));
      }
    }
    result.add(VariantDefinition(flagEnum.displayName, values));
  }

  return result;
}
