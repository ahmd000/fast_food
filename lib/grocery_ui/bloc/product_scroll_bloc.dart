import 'package:app/src/models/product_model.dart';
import 'package:app/src/resources/api_provider.dart';
import 'package:rxdart/rxdart.dart';

class ProductsBloc {
  List<Product> products = [];
  var productsFilter = new Map<String, dynamic>();
  final apiProvider = ApiProvider();

  final _productsFetcher = BehaviorSubject<List<Product>>();
  ValueStream<List<Product>> get allProducts => _productsFetcher.stream;

  fetchAllProducts(int id) async {
    print(id.toString());
    productsFilter['id'] = id.toString();
    products = await apiProvider.fetchProductList(productsFilter);
    _productsFetcher.sink.add(products);
  }
}