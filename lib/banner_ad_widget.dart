import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class BannerAdWidget extends StatefulWidget {
  const BannerAdWidget({super.key});

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  late BannerAd bannerAd;
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();

    // Initialize Banner Ad
    bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-3940256099942544/6300978111', // ✅ Test Ad ID
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          debugPrint("Banner Ad loaded successfully");
          setState(() => isLoaded = true);
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint("Banner Ad failed to load: $error");
          ad.dispose();
        },
        onAdOpened: (ad) => debugPrint("Banner Ad opened"),
        onAdClosed: (ad) => debugPrint("Banner Ad closed"),
      ),
    );

    bannerAd.load();
  }

  @override
  void dispose() {
    bannerAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isLoaded
        ? SizedBox(
      width: MediaQuery.of(context).size.width, // Full screen width
      height: bannerAd.size.height.toDouble(),
      child: AdWidget(ad: bannerAd),
    )
        : const SizedBox(height: 50); // Reserve space so layout doesn't jump
  }
}
