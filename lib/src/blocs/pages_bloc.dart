import 'dart:convert';
import 'package:app/src/models/pages_model/page_model.dart';
import 'package:rxdart/rxdart.dart';
import './../resources/api_provider.dart';

class PageBloc {

  final apiProvider = ApiProvider();
  final _pageFetcher = BehaviorSubject<PageModel>();

  ValueStream<PageModel> get allPage => _pageFetcher.stream;

  getPage(String id) async {
    final response = await apiProvider.get('/wp-admin/admin-ajax.php?action=build-app-online-page&id=' + id.toString());
    print('getting page');
    print(response.statusCode);
    if(response.statusCode == 200) {
      PageModel page = PageModel.fromJson(json.decode(response.body));
      _pageFetcher.sink.add(page);
    } else {
      //
    }
  }

  dispose() {
    _pageFetcher.close();
  }
}

final PageBloc pageBloc = PageBloc();
