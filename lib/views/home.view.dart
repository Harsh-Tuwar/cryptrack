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
    final url = Uri.parse(api_url_assets);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final json = convert.jsonDecode(response.body);
      final List<dynamic> cryptoAssets = json['data'];
      final usdToCad = await getRates();

      final List<dynamic> modifiedCryptoAssets = cryptoAssets.map((e) {
        e['priceCad'] = double.parse(e['priceUsd']) /
            double.parse(usdToCad[0]['rateUsd'].toString());
        return e;
      }).toList();

      return modifiedCryptoAssets;
    } else {
      print(response.body);
      throw Exception('Failed to load assets');
    }
  }

  Future<dynamic> getRates() async {
    final url = Uri.parse(api_url_rates);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final json = convert.jsonDecode(response.body);
      final List<dynamic> rates = json['data'];

      return rates.where((element) => element['symbol'] == 'CAD').toList();
    } else {
      print(response.body);
      throw Exception('Failed to load rates');
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
      extendBody: true,
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            title: Text(
              'CrypTrack',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            floating: true,
            pinned: true,
            snap: true,
            backgroundColor: Colors.white,
          ),
          SliverToBoxAdapter(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _renderPortfolioCard(),
                SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: _renderAssets(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _renderPortfolioCard() {
    return Container(
      margin: const EdgeInsets.all(20),
      width: MediaQuery.of(context).size.width,
      child: Card(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Total Portfolio value:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                '\$ 100.00',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  FutureBuilder _renderAssets() {
    return FutureBuilder(
      future: getAssets(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final dynamic cyptoAsset = (snapshot.data as List)[index];
              int pricePrecision =
                  double.parse(cyptoAsset['priceCad'].toString()).round() > 0
                      ? 2
                      : 8;

              String price = num.tryParse(cyptoAsset['priceCad'].toString())!
                  .toStringAsFixed(pricePrecision);
              return Card(
                child: ListTile(
                  title: Text(
                    cyptoAsset['name'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
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
    );
  }
}
