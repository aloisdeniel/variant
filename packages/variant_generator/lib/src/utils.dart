import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/analysis/session.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';

extension LibraryAstExtensions on Element {
  AstNode? findAstNode() {
    final session = this.session as AnalysisSession;
    final parsedLibResult =
        session.getParsedLibraryByElement(library!) as ParsedLibraryResult;
    final elDeclarationResult = parsedLibResult.getElementDeclaration(this);
    return elDeclarationResult?.node;
  }
}
