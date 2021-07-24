import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:user/Locale/locales.dart';
import 'package:user/Maps/UI/location_page.dart';
import 'package:user/Themes/colors.dart';
import 'package:user/Themes/constantfile.dart';
import 'package:user/baseurlp/baseurl.dart';
import 'package:user/parcel/pharmacybean/parceladdress.dart';
import 'package:user/parcel/receiveraddress.dart';
import 'package:user/bean/latlng.dart';
import 'package:user/Routes/routes.dart';

class AddressFrom extends StatefulWidget {
  final dynamic vendor_name;
  final dynamic vendor_id;
  final dynamic distance;

  AddressFrom(this.vendor_name, this.vendor_id, this.distance);

  @override
  State<StatefulWidget> createState() {
    return AddressFromState();
  }
}

class AddressFromState extends State<AddressFrom> {
  TextEditingController houseno = TextEditingController();
  TextEditingController pincode = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController landmark = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController state = TextEditingController();
  TextEditingController sendername = TextEditingController();
  TextEditingController sendercontact = TextEditingController();

  GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: apiKey);

  bool isFetchStore = false;
  bool enterFirst = false;

  double lat = 0.0;
  double lng = 0.0;

  String currentAddress = '';

  @override
  void initState() {
    // _getLocation(context,locale);
    super.initState();
  }

  void _getLocation(BuildContext context, AppLocalizations locale) async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      bool isLocationServiceEnableds =
          await Geolocator.isLocationServiceEnabled();
      if (isLocationServiceEnableds) {
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        double lat = position.latitude;
        double lng = position.longitude;
        final coordinates = new Coordinates(lat, lng);
        await Geocoder.local
            .findAddressesFromCoordinates(coordinates)
            .then((value) {
          for (int i = 0; i < value.length; i++) {
            if (value[i].locality != null && value[i].locality.length > 1) {
              setState(() {
                city.text = value[i].locality;
                pincode.text = value[i].postalCode;
                state.text = value[i].adminArea;
              });
              break;
            }
          }
        });
      } else {
        await Geolocator.openLocationSettings().then((value) {
          if (value) {
            _getLocation(context,locale);
          } else {
            Toast.show(locale.locationPermissionIsRequired, context,
                duration: Toast.LENGTH_SHORT);
          }
        }).catchError((e) {
          Toast.show(locale.locationPermissionIsRequired, context,
              duration: Toast.LENGTH_SHORT);
        });
      }
    } else if (permission == LocationPermission.denied) {
      LocationPermission permissiond = await Geolocator.requestPermission();
      if (permissiond == LocationPermission.whileInUse ||
          permissiond == LocationPermission.always) {
        _getLocation(context,locale);
      } else {
        Toast.show(locale.locationPermissionIsRequired, context,
            duration: Toast.LENGTH_SHORT);
      }
    } else if (permission == LocationPermission.deniedForever) {
      await Geolocator.openAppSettings().then((value) {
        _getLocation(context,locale);
      }).catchError((e) {
        Toast.show(locale.locationPermissionIsRequired, context,
            duration: Toast.LENGTH_SHORT);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context);
    if(!enterFirst){
      setState(() {
        enterFirst = true;
      });
      _getLocation(context,locale);
    }
    return Scaffold(
      backgroundColor: kCardBackgroundColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(52.0),
        child: AppBar(
          backgroundColor: kWhiteColor,
          titleSpacing: 0.0,
          title: Text(
            locale.addressNotFound,
            style: TextStyle(
                fontSize: 18, color: black_color, fontWeight: FontWeight.w400),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(left: 10.0, top: 10, bottom: 10.0),
              child: Text(
                locale.senderAddress,
                style: TextStyle(
                    fontSize: 18,
                    color: black_color,
                    fontWeight: FontWeight.w400),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text(
                      locale.senderName,
                      style: TextStyle(
                          fontSize: 18,
                          color: black_color,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Card(
                    elevation: 2,
                    color: kWhiteColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Container(
                      height: 52,
                      alignment: Alignment.centerLeft,
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.only(left: 10.0),
                      child: TextFormField(
                        maxLines: 1,
                        controller: sendername,
                        decoration: InputDecoration(
                          hintText: locale.senderName,
                          hintStyle: TextStyle(fontSize: 15),
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text(
                      locale.senderContactNo,
                      style: TextStyle(
                          fontSize: 18,
                          color: black_color,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Card(
                    elevation: 2,
                    color: kWhiteColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Container(
                      height: 52,
                      alignment: Alignment.centerLeft,
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.only(left: 10.0),
                      child: TextFormField(
                        maxLines: 1,
                        controller: sendercontact,
                        keyboardType: TextInputType.number,
                        maxLength: 10,
                        decoration: InputDecoration(
                          hintText: locale.senderContactNo,
                          hintStyle: TextStyle(fontSize: 15),
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text(
                      locale.address,
                      style: TextStyle(
                          fontSize: 18,
                          color: black_color,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, PageRoutes.searchloc).then((value){
                        if (value != null) {
                          print('${value.toString()}');
                          BackLatLng back = value;
                          _getCameraMoveLocation(LatLng(double.parse('${back.lat}'), double.parse('${back.lng}')),back.address);
                        }
                      });
                    },
                    behavior: HitTestBehavior.opaque,
                    child: Card(
                      elevation: 2,
                      color: kWhiteColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Container(
                        alignment: Alignment.centerLeft,
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.only(left: 10.0),
                        child: TextFormField(
                          maxLines: 5,
                          controller: address,
                          enabled: (address.text.length == 0) ? false : true,
                          decoration: InputDecoration(
                            hintText: locale.enteryouraddress,
                            hintStyle: TextStyle(fontSize: 15),
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                          ),
                          onChanged: (value) {
                            if(value.length==1){
                              Navigator.pushNamed(context, PageRoutes.searchloc).then((value){
                                if (value != null) {
                                  print('${value.toString()}');
                                  BackLatLng back = value;
                                  _getCameraMoveLocation(LatLng(double.parse('${back.lat}'), double.parse('${back.lng}')),back.address);
                                }
                              });
                            }
                          },
                          onTap: () {},
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text(
                      locale.houseNoAndFlatNo,
                      style: TextStyle(
                          fontSize: 18,
                          color: black_color,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Card(
                    elevation: 2,
                    color: kWhiteColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Container(
                      height: 52,
                      alignment: Alignment.centerLeft,
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.only(left: 10.0),
                      child: TextFormField(
                        maxLines: 1,
                        controller: houseno,
                        decoration: InputDecoration(
                          hintText: locale.houseNoAndFlatNo,
                          hintStyle: TextStyle(fontSize: 15),
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 10.0),
                              child: Text(
                                locale.pinCode,
                                style: TextStyle(
                                    fontSize: 15,
                                    color: black_color,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Card(
                              elevation: 2,
                              color: kWhiteColor,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Container(
                                height: 52,
                                alignment: Alignment.center,
                                width: MediaQuery.of(context).size.width,
                                child: TextFormField(
                                  maxLines: 1,
                                  controller: pincode,
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    hintText: locale.pinCode,
                                    hintStyle: TextStyle(fontSize: 15),
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 10.0),
                              child: Text(
                                locale.city,
                                style: TextStyle(
                                    fontSize: 15,
                                    color: black_color,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Card(
                              elevation: 2,
                              color: kWhiteColor,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Container(
                                height: 52,
                                alignment: Alignment.center,
                                width: MediaQuery.of(context).size.width,
                                child: TextFormField(
                                  maxLines: 1,
                                  controller: city,
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                    hintText: locale.city,
                                    enabled: false,
                                    border: InputBorder.none,
                                    hintStyle: TextStyle(fontSize: 15),
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text(
                      locale.landMark,
                      style: TextStyle(
                          fontSize: 18,
                          color: black_color,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Card(
                    elevation: 2,
                    color: kWhiteColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Container(
                      height: 52,
                      alignment: Alignment.centerLeft,
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.only(left: 10.0),
                      child: TextFormField(
                        maxLines: 1,
                        controller: landmark,
                        decoration: InputDecoration(
                          hintText: locale.landMark,
                          hintStyle: TextStyle(fontSize: 15),
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text(
                      locale.state,
                      style: TextStyle(
                          fontSize: 18,
                          color: black_color,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Card(
                    elevation: 2,
                    color: kWhiteColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Container(
                      height: 52,
                      alignment: Alignment.centerLeft,
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.only(left: 10.0),
                      child: TextFormField(
                        maxLines: 1,
                        controller: state,
                        decoration: InputDecoration(
                          hintText: locale.state,
                          hintStyle: TextStyle(fontSize: 15),
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              child: GestureDetector(
                onTap: () {
                  if (houseno.text != null &&
                      pincode.text != null &&
                      city.text != null &&
                      landmark.text != null &&
                      address.text != null &&
                      state.text != null &&
                      lat != null &&
                      lng != null &&
                      sendername.text != null &&
                      sendercontact.text != null) {
                    ParcelAddress parcelAddress = ParcelAddress(
                        houseno.text,
                        pincode.text,
                        city.text,
                        landmark.text,
                        address.text,
                        state.text,
                        lat,
                        lng,
                        sendername.text,
                        sendercontact.text);
                    // ParcelAddress parcelAddress = ParcelAddress(
                    //     '12',
                    //     '131001',
                    //     'sonipat',
                    //     'sonipat',
                    //     'sonipat',
                    //     'haryana',
                    //     12.8525,
                    //     27.8568,
                    //     'Ajit Singh',
                    //     '9467313652');
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddressTo(
                                widget.vendor_name,
                                widget.vendor_id,
                                widget.distance,
                                parcelAddress)));
                  } else {
                    Toast.show(locale.pleaseEnterAllDetailsToContinue, context,
                        duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
                  }
                },
                child: Card(
                  elevation: 2,
                  color: kMainColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Container(
                    height: 52,
                    padding: EdgeInsets.all(10.0),
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                     locale.submit,
                      style: TextStyle(fontSize: 18, color: kWhiteColor),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  void getPlaces(context) async {
    PlacesAutocomplete.show(
      context: context,
      apiKey: apiKey,
      mode: Mode.fullscreen,
      sessionToken: Uuid().generateV4(),
      onError: (response) {
        print('${response.errorMessage}');
      },
      language: "en",
    ).then((value) {
      displayPrediction(value);
    }).catchError((e) {
      print(e);
    });
  }

  Future<Null> displayPrediction(Prediction p) async {
    if (p != null) {
      PlacesDetailsResponse detail =
          await _places.getDetailsByPlaceId(p.placeId);
      final lat = detail.result.geometry.location.lat;
      final lng = detail.result.geometry.location.lng;
      _getCameraMoveLocation(
          LatLng(lat, lng), '${detail.result.formattedAddress}');
    }
  }

  void _getCameraMoveLocation(LatLng data, addressd) async {
    setState(() {
      lat = data.latitude;
      lng = data.longitude;
      currentAddress = '${addressd}';
    });
    final coordinates = new Coordinates(lat, lng);
    await Geocoder.local
        .findAddressesFromCoordinates(coordinates)
        .then((value) {
      for (int i = 0; i < value.length; i++) {
        print('${value[i].locality}');
        if (value[i].locality != null && value[i].locality.length > 1) {
          setState(() {
            city.text = value[i].locality;
            pincode.text = value[i].postalCode;
            state.text = value[i].adminArea;
            currentAddress =
                currentAddress.replaceAll('${value[i].locality},', '');
            currentAddress = currentAddress.replaceAll('${pincode.text},', '');
            currentAddress = currentAddress.replaceAll('${state.text},', '');
            currentAddress =
                currentAddress.replaceAll('${value[i].locality}', '');
            currentAddress = currentAddress.replaceAll('${pincode.text}', '');
            currentAddress = currentAddress.replaceAll('${state.text}', '');
            currentAddress =
                currentAddress.replaceAll('${value[i].countryName}', '');
            address.text = currentAddress;
          });
          break;
        }
      }
    });
  }
}
