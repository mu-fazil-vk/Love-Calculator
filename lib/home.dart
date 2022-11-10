// ignore_for_file: prefer_typing_uninitialized_variables, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'functions/api.dart';

class ScreenHome extends StatefulWidget {
  const ScreenHome({Key? key}) : super(key: key);

  @override
  State<ScreenHome> createState() => _ScreenHomeState();
}

class _ScreenHomeState extends State<ScreenHome> {
  late BannerAd _bannerAd;
  bool _isAdLoaded = false;

  late InterstitialAd _interstitialAd;
  bool _isInterstitialAdLoaded = false;

  final TextEditingController _name1Controller = TextEditingController();
  final TextEditingController _name2Controller = TextEditingController();

  var result;
  var Name1;
  var Name2;
  var Percentage = '0';
  var Result;

  var visible_indicator = false;
  var visible_gif = true;

  // dispose it when the widget is unmounted
  @override
  void dispose() {
    _name1Controller.dispose();
    _name2Controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _initBannerAd();
    _initInterstitialAd();
  }

  _initBannerAd() {
    _bannerAd = BannerAd(
        size: AdSize.banner,
        adUnitId: 'ca-app-pub-3940256099942544/6300978111',
        listener: BannerAdListener(
            onAdLoaded: (ad) {
              setState(() {
                _isAdLoaded = true;
              });
            },
            onAdFailedToLoad: (ad, error) {}),
        request: const AdRequest());

    _bannerAd.load();
  }

  void _initInterstitialAd() {
    InterstitialAd.load(
      adUnitId: 'ca-app-pub-3940256099942544/1033173712',
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: onAdLoaded,
        onAdFailedToLoad: (error) {},
      ),
    );
  }

  void onAdLoaded(InterstitialAd ad) {
    _interstitialAd = ad;
    _isInterstitialAdLoaded = true;

    _interstitialAd.fullScreenContentCallback =
        FullScreenContentCallback(onAdDismissedFullScreenContent: (ad) {
      _interstitialAd.dispose();
    }, onAdFailedToShowFullScreenContent: (ad, error) {
      ad.dispose();
    });
  }

  @override
  Widget build(BuildContext context) {
    var _text1 = '';
    var _text2 = '';
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Center(
                child: Text(
                  'Love Calculator 💖',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Column(
                children: [
                  TextFormField(
                    controller: _name1Controller,
                    onChanged: (text) => setState(() => _text1),
                    decoration: InputDecoration(
                        icon: const Icon(Icons.face),
                        labelText: 'Enter your name',
                        labelStyle: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                        errorText: _errorText1,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _name2Controller,
                    onChanged: (text) => setState(() => _text2),
                    decoration: InputDecoration(
                        icon: const Icon(Icons.face),
                        labelText: 'Enter your Lover name',
                        labelStyle: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                        errorText: _errorText2,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton.icon(
                      onPressed: _name1Controller.value.text.isNotEmpty &&
                              _name2Controller.value.text.isNotEmpty
                          ? _submit
                          : null,
                      icon: const Icon(Icons.monitor_heart),
                      label: const Text('Calculate'))
                ],
              ),
              const SizedBox(
                height: 40,
              ),
              Visibility(
                  child: Image.asset(
                    'assets/gifs/love-heart-icegif.gif',
                    width: 350,
                    height: 350,
                  ),
                  visible: visible_gif),
              Visibility(
                visible: visible_indicator,
                child: Column(
                  children: [
                    Text('$Name2 💝 $Name1',
                        style: const TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold)),
                    const SizedBox(
                      height: 30,
                    ),
                    CircularPercentIndicator(
                      radius: 80.0,
                      lineWidth: 25,
                      animation: true,
                      animationDuration: 6000,
                      percent: (double.parse(Percentage) / 100),
                      linearGradient: const LinearGradient(
                        colors: [
                          Colors.red,
                          Colors.yellow,
                          Colors.green,
                          Colors.blue
                        ],
                      ),
                      center: Text(Percentage + '%',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20.0)),
                      //progressColor: Colors.green,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Text('Result: $Result',
                        style: const TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
        ),
      )),
      bottomNavigationBar: _isAdLoaded
          ? SizedBox(
              height: _bannerAd.size.height.toDouble(),
              width: _bannerAd.size.width.toDouble(),
              child: AdWidget(ad: _bannerAd),
            )
          : const SizedBox(),
    );
  }

//for your name
  String? get _errorText1 {
    if (_name1Controller.text.isEmpty || _name1Controller.text == ' ') {
      return 'Please enter a name';
    }
    if (_name1Controller.text == _name2Controller.text) {
      return 'Please enter different names';
    }
    if (_name1Controller.text.length < 3) {
      return 'Name too short';
    }
    return null;
  }

  //for lover
  String? get _errorText2 {
    if (_name2Controller.text.isEmpty || _name2Controller.text == ' ') {
      return 'Please enter a name';
    }
    if (_name1Controller.text == _name2Controller.text) {
      return 'Please enter different names';
    }
    if (_name2Controller.text.length < 3) {
      return 'Name too short';
    }
    return null;
  }

  Future<void> _submit() async {
    if (_isInterstitialAdLoaded) {
      _interstitialAd.show();
    }
    // if there is no error text
    if (_errorText1 == null && _errorText2 == null) {
      // notify the parent widget via the onSubmit callback
      result = await APIService.getData(
          _name1Controller.text, _name2Controller.text);
      Name1 = result['fname'];
      Name2 = result['sname'];
      Result = result['result'];
      setState(() {
        Percentage = result['percentage'];
        visible_gif = false;
        visible_indicator = true;
      });
    }
  }
}
