import 'package:dio/dio.dart';
import 'package:shopease/core/constants/app_constants.dart';
import 'package:shopease/domain/entities/product.dart';

abstract class ProductRemoteDataSource {
  Future<List<Product>> getProducts();
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final Dio dio;

  ProductRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<Product>> getProducts() async {
    final response = await dio.get('${AppConstants.baseUrl}${AppConstants.productsEndpoint}');
    return (response.data as List).map((product) => ProductModel.fromJson(product)).toList();
  }
}