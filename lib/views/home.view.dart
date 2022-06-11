import 'package:crypto_tracker/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class HomeView extends StatefulWidget {
  const HomeView({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  Future<List<dynamic>> getAssets() async {
    final url = Uri.parse(api_url);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final json = convert.jsonDecode(response.body);
      final List<dynamic> cryptoAssets = json['data'];

      return cryptoAssets;
    } else {
      print(response.body);
      throw Exception('Failed to load assets');
    }
  }

  @override
  void initState() {
    getAssets();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: RefreshIndicator(
          onRefresh: () => getAssets(),
          child: FutureBuilder(
            future: getAssets(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemBuilder: (context, index) {
                    final dynamic cyptoAsset = (snapshot.data as List)[index];
                    String price = num.tryParse(cyptoAsset['priceUsd'])!
                        .toStringAsFixed(2);
                    return Card(
                      child: ListTile(
                        title: Text(
                          cyptoAsset['name'],
                          style: TextStyle(
                              color: Colors.orange.shade800,
                              fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(cyptoAsset['symbol']),
                        trailing: Text(
                          '\$$price',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: (snapshot.data as List).length,
                );
              }
              if (snapshot.hasError) {
                return const Center(
                  child: Text('Unable to load assets'),
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ));
  }
}
