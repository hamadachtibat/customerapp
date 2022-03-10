import 'dart:math';
import 'package:abg_utils/abg_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ondemandservice/model/model.dart';
import 'package:ondemandservice/ui/booking/payment.dart';
import 'package:provider/provider.dart';
import '../strings.dart';
import '../theme.dart';

class CheckOut2Screen extends StatefulWidget {
  @override
  _CheckOut2ScreenState createState() => _CheckOut2ScreenState();
}

class _CheckOut2ScreenState extends State<CheckOut2Screen> {

  double windowWidth = 0;
  double windowHeight = 0;
  double windowSize = 0;
  final ScrollController _scrollController = ScrollController();
  final _editControllerCoupon = TextEditingController();
  final _editControllerHint = TextEditingController();
  final ScrollController _scrollController2 = ScrollController();
  late MainModel _mainModel;
  late PriceTotalForCardData _totalPrice;

  @override
  void initState() {
    _mainModel = Provider.of<MainModel>(context,listen:false);
    _scrollController.addListener(_scrollListener);
    _editControllerHint.text = localSettings.hint;
    super.initState();
  }

  double _scroller = 20;
  _scrollListener() {
    var _scrollPosition = _scrollController.position.pixels;
    _scroller = 20-(_scrollPosition/(windowHeight*0.1/20));
    if (_scroller < 0)
      _scroller = 0;
    setState(() {
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _scrollController2.dispose();
    _editControllerHint.dispose();
    _editControllerCoupon.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    windowSize = min(windowWidth, windowHeight);
    return Scaffold(
      backgroundColor: (theme.darkMode) ? theme.blackColorTitleBkg : theme.colorBackground,
      body: Directionality(
      textDirection: strings.direction,
      child: Stack(
          children: [
            NestedScrollView(
              controller: _scrollController,
              headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                      expandedHeight: windowHeight*0.2,
                      automaticallyImplyLeading: false,
                      pinned: true,
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      flexibleSpace: ClipPath(
                        clipper: ClipPathClass23((_scroller < 5) ? 5 : _scroller),
                        child: Container(
                            child: Stack(
                              children: [
                                FlexibleSpaceBar(
                                    collapseMode: CollapseMode.pin,
                                    background: _title(),
                                    titlePadding: EdgeInsets.only(bottom: 10, left: 20, right: 20),
                                )
                              ],
                            )),
                      ))
                ];
              },
              body: Container(
                width: windowWidth,
                height: windowHeight,
                child: ListView(
                  children: _body(),
                ),
              ),
            ),

            appbar1((_scroller > 1) ? Colors.transparent :
                  (theme.darkMode) ? Colors.black : Colors.white,
                (theme.darkMode) ? Colors.white : Colors.black,
                (_scroller > 5) ? "" : getTextByLocale(_mainModel.currentService.name, strings.locale), context,
                    () {goBack();}),

            if (!_booking)
            Container(
              alignment: Alignment.bottomCenter,
              child: button2(strings.get(46), /// "CONTINUE"
                  theme.mainColor, (){
                    String _desc = "";
                    _mainModel.cartUser = true;
                    paymentProcess(_totalPrice.total, _desc, _waits, context, _book2, _mainModel);

                  }, radius: 0),
            ),

            IEasyDialog2(setPosition: (double value){_show = value;}, getPosition: () {return _show;}, color: Colors.grey,
              getBody: _getDialogBody, backgroundColor: (theme.darkMode) ? Colors.black : Colors.white,),

            if (_wait)
              Center(child: Container(child: Loader7v1(color: theme.mainColor,))),


          ])),
    );
  }

  bool _wait = false;
  _waits(bool value){
    _wait = value;
    _redraw();
  }
  _redraw(){
    if (mounted)
      setState(() {
      });
  }

  Widget _getDialogBody(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        UnconstrainedBox(
            child: Container(
              height: windowWidth/3,
              width: windowWidth/3,
              child: image11(
                  theme.booking5LogoAsset ? Image.asset("assets/ondemands/ondemand33.png", fit: BoxFit.contain) :
                  CachedNetworkImage(
                      imageUrl: theme.booking5Logo,
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.contain,
                          ),
                        ),
                      )
                  ),
                  //Image.asset("assets/ondemands/ondemand33.png", fit: BoxFit.contain)
                  20),
            )),
        SizedBox(height: 20,),
        Text(strings.get(116), // "Thank you!",
            textAlign: TextAlign.center, style: theme.style20W800),
        SizedBox(height: 20,),
        Text(strings.get(115), // "Your booking has been successfully submitted, you will receive a confirmation soon."
            textAlign: TextAlign.center, style: theme.style14W400),
        SizedBox(height: 40,),
        Text("${strings.get(232)} $cartLastAddedId", /// "Booking ID",
            textAlign: TextAlign.center, style: theme.style14W400),
        SizedBox(height: 40,),
        Container(
            alignment: Alignment.center,
            child: Container(
                width: windowWidth/2,
                child: button2(strings.get(114), theme.mainColor, // "Ok",
                        (){
                      setState(() {
                        _show = 0;
                      });
                      goBack();
                      goBack();
                    }))
        ),
        SizedBox(height: 20,),
      ],
    );
  }

  _title() {
    var _data = _mainModel.service.getTitleImage();
    if (_data.serverPath.isEmpty)
      return Container();
    return Container(
      color: (theme.darkMode) ? theme.blackColorTitleBkg : theme.colorBackground,
      height: windowHeight * 0.3,
      width: windowWidth,
      child: Stack(
        children: [
          Container(
                alignment: Alignment.bottomRight,
                child: Container(
                  width: windowWidth,
                  margin: EdgeInsets.only(bottom: 10),
                  child: CachedNetworkImage(
                      imageUrl: _data.serverPath,
                      imageBuilder: (context, imageProvider) => Container(
                        width: double.maxFinite,
                        alignment: Alignment.bottomRight,
                        child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              )),
                        ),
                      )
                  ),
                )),
        ],
      ),
    );
  }


  _body(){
    List<Widget> list = [];

    _totalPrice = cartGetTotalForAllServices();
    tablePricesV4(list, cart,
      strings.get(221), /// "Addons"
      strings.get(235), /// "Subtotal"
      strings.get(236), /// "Discount"
      strings.get(276), /// "VAT/TAX"
      strings.get(263) /// "Total amount"
    );

    paymentsList(cartCurrentProvider != null ? cartCurrentProvider! : ProviderData.createEmpty(), list, _redraw);

    list.add(SizedBox(height: 150,));
    return list;
  }

  bool _booking = false;
  double _show = 0;

  _book2(){
    _booking = true;
    setState(() {
      _show = 1;
    });
  }
}
