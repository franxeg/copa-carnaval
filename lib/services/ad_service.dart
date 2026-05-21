import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdService {
  static final AdService _instance = AdService._();
  factory AdService() => _instance;
  AdService._();

  bool _initialized = false;

  bool get isAvailable => !kIsWeb;

  String get _bannerAdUnitId => 'ca-app-pub-3940256099942544/6300978111';

  String get _interstitialAdUnitId => 'ca-app-pub-3940256099942544/1033173712';

  Future<void> initialize() async {
    if (_initialized || !isAvailable) return;
    try {
      await MobileAds.instance.initialize();
      _initialized = true;
    } catch (e) {
      debugPrint('AdMob initialization failed: $e');
    }
  }

  BannerAd createBannerAd({
    required void Function(Ad) onAdLoaded,
    required void Function(Object) onAdFailedToLoad,
    AdSize? adSize,
  }) {
    return BannerAd(
      adUnitId: _bannerAdUnitId,
      size: adSize ?? AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: onAdLoaded,
        onAdFailedToLoad: (ad, error) {
          onAdFailedToLoad(error);
          ad.dispose();
        },
      ),
    );
  }

  InterstitialAd? _interstitialAd;

  void loadInterstitialAd() {
    if (!isAvailable) return;
    InterstitialAd.load(
      adUnitId: _interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _interstitialAd = null;
            },
          );
        },
        onAdFailedToLoad: (error) {
          debugPrint('Interstitial ad failed to load: $error');
          _interstitialAd = null;
        },
      ),
    );
  }

  void showInterstitialAd() {
    _interstitialAd?.show();
  }
}
