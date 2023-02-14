import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdMobileService {
  static String? get bannerAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-1856488952723088/3482179890";
    } else if (Platform.isIOS) {
      return "ca-app-pub-1856488952723088/4834241273";
    }
    return null;
  }

  static String? get nativeAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-1856488952723088/2148098684";
    } else if (Platform.isIOS) {
      return "ca-app-pub-1856488952723088/4834241273";
    }
    return null;
  }

  static final BannerAdListener bannerListener = BannerAdListener(
    onAdLoaded: (ad) => debugPrint("Ad loaded"),
    onAdFailedToLoad: (ad, error) {
      ad.dispose();
      debugPrint("Ad failed to load: $error");
    },
    onAdOpened: (ad) => debugPrint("Ad Opended"),
    onAdClosed: (ad) => debugPrint("Ad Closed"),
  );

  static final NativeAdListener nativeListener = NativeAdListener(
    onAdLoaded: (ad) => debugPrint("Ad loaded"),
    onAdFailedToLoad: (ad, error) {
      ad.dispose();
      debugPrint("Ad failed to load: $error");
    },
    onAdOpened: (ad) => debugPrint("Ad Opended"),
    onAdClosed: (ad) => debugPrint("Ad Closed"),
  );
}
