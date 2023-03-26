import 'package:equatable/equatable.dart';

class VariantDefinition {
  const VariantDefinition(this.name, this.values);
  final String name;
  final List<VariantValueDefinition> values;
}

class VariantValueDefinition extends Equatable {
  const VariantValueDefinition(this.variant, this.name, this.flag);
  final String variant;
  final String name;
  final int flag;

  @override
  List<Object?> get props => [variant, name];
}
