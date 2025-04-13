import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shopease/main.dart';
import 'package:shopease/presentation/screens/product_list_screen.dart';

void main() {
  testWidgets('App loads successfully', (WidgetTester tester) async {
    // Build our app and trigger a frame
    await tester.pumpWidget(const ShopEaseApp());

    // Verify the ProductListScreen loads
    expect(find.byType(ProductListScreen), findsOneWidget);
    
    // Initially shows loading indicator
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    
    // Let the app load products (simulate API response)
    await tester.pumpAndSettle();
    
    // Verify product grid appears
    expect(find.byType(GridView), findsOneWidget);
  });
}