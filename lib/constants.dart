// daa1a79d-2384-4a45-964a-0bf53108912a

List<String> asset_ids = [
  'bitcoin',
  'ethereum',
  'crypto-com-coin',
  'polygon',
  'shiba-inu',
  'cardano',
  'algorand',
];

String api_url_assets =
    'https://api.coincap.io/v2/assets?ids=${asset_ids.join(",")}';

String api_url_rates = 'https://api.coincap.io/v2/rates';
