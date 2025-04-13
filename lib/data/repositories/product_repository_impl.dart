import 'package:shopease/data/datasources/product_remote_data_source.dart';
import 'package:shopease/domain/entities/product.dart';
import 'package:shopease/domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  ProductRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Product>> getProducts() async {
    return await remoteDataSource.getProducts();
  }
}