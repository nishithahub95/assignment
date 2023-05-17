import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:resto_app_ui/Model/Restorents.dart';
import 'package:resto_app_ui/Screeen/widgets/custombottam_navigationbar.dart';
import 'package:resto_app_ui/Screeen/widgets/mylocation.dart';
import 'package:resto_app_ui/Screeen/widgets/round_button.dart';
import 'package:http/http.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var selected = 0;
  String search = "";
  final TextEditingController searchController = TextEditingController();
  String address = 'my address';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    determinePosition();
  }

  Future<void> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position position = await Geolocator.getCurrentPosition();

    getAddressFromLatLong(position);
  }

  Future<void> getAddressFromLatLong(Position position) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    Placemark place = placemarks[0];
    String myAddress = ' ${place.locality}, ${place.administrativeArea}';

    setState(() {
      address = myAddress;
    });
  }

  Future<Restorents> getRestorents() async {
    Response response = await post(
        Uri.parse('https://theoptimiz.com/restro/public/api/get_resturants'),
        body: {"lat": "25.22", "lng": "45.32"});
    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      return Restorents.fromJson(data);
    } else {
      print(null);
      return Restorents.fromJson(data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.45,
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                      Color(0xffFFECD2),
                      Color(0xffffffff),
                    ])),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    children: [
                      myLocation(address: address),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: const [
                          Text(
                            'Stories',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Expanded(
                        child: FutureBuilder<Restorents>(
                          future: getRestorents(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  // itemCount: 4,
                                  itemCount: snapshot.data!.data!.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: Container(
                                        height: 200,
                                        width: 150,
                                        decoration: BoxDecoration(
                                            color: Colors.orange,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: NetworkImage(snapshot.data!.data![index].primaryImage.toString()))),
                                      ),
                                    );
                                  });
                            } else {
                              return Text('Loading');
                            }
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.90,
                        height: MediaQuery.of(context).size.height * 0.06,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                        ),
                        decoration: const BoxDecoration(
                          // color: Color(0xB3ffffff),
                          color: Color(0xfff2f2f2),
                          borderRadius: BorderRadius.all(
                            Radius.circular(
                              20,
                            ),
                          ),
                        ),
                        child: Center(
                          child: TextFormField(
                            cursorColor: Colors.black,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                            decoration: const InputDecoration(
                                hintText: 'Search Restaurants',
                                hintStyle: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w400),
                                prefixIcon: Icon(
                                  Icons.search_rounded,
                                  size: 25,
                                  color: Colors.black,
                                ),
                                border: InputBorder.none),
                            onChanged: (String? value) {
                              setState(() {
                                search = value.toString();
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                ),
              ),
              RoundButton(
                selected: selected,
                callback: (int index) {
                  setState(() {
                    selected = index;
                  });
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    Text(
                      'Nearby Restaurants',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: FutureBuilder<Restorents>(
                  future: getRestorents(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          scrollDirection: Axis.vertical,
                          // itemCount: 4,
                          itemCount: snapshot.data!.data!.length,
                          itemBuilder: (context, index) {
                            if (searchController.text.isEmpty) {
                              return Padding(
                                padding: const EdgeInsets.all(15),
                                child: Container(
                                  height: 250,
                                  width:
                                      MediaQuery.of(context).size.width * 0.70,
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.2),
                                        spreadRadius: 4,
                                        blurRadius: 7,
                                        offset: Offset(2, 3),
                                      )
                                    ],
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Card(
                                    elevation: 10,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Column(
                                      children: [
                                        Container(
                                          height: 150,
                                          decoration: BoxDecoration(
                                              borderRadius:const BorderRadius.only(
                                                  topLeft: Radius.circular(15),
                                                  topRight:
                                                      Radius.circular(15)),
                                              image: DecorationImage(
                                                  fit: BoxFit.fitWidth,
                                                  image: NetworkImage(snapshot
                                                      .data!
                                                      .data![index]
                                                      .primaryImage
                                                      .toString()))),
                                          child: Align(
                                            alignment: Alignment.bottomRight,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.green.shade400,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(4.0),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                        snapshot.data!
                                                            .data![index].rating
                                                            .toString(),
                                                        style:const TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                     const Icon(
                                                        Icons.star,
                                                        color: Colors.white,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    snapshot
                                                        .data!.data![index].name
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                     const Icon(
                                                        Icons.discount,
                                                        color: Colors.red,
                                                      ),
                                                      Text(snapshot.data!.data![index].discount.toString() + "% FLAT OFF",
                                                        style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text('.' + snapshot.data!.data![index].tags.toString(),
                                                    style: TextStyle(fontWeight: FontWeight.w400),
                                                  ),
                                                  Text(snapshot.data!.data![index].distance.toString() + "KM")
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            } else if (snapshot.data!.data![index].name.toString().toLowerCase().contains(searchController.text.toLowerCase())) {
                              return Padding(
                                padding: const EdgeInsets.all(15),
                                child: Container(
                                  height: 250,
                                  width:
                                      MediaQuery.of(context).size.width * 0.70,
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.2),
                                        spreadRadius: 4,
                                        blurRadius: 7,
                                        offset: Offset(2, 3),
                                      )
                                    ],
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Card(
                                    elevation: 10,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Column(
                                      children: [
                                        Container(
                                          height: 150,
                                          decoration: BoxDecoration(
                                              borderRadius: const BorderRadius.only(
                                                  topLeft: Radius.circular(15),
                                                  topRight:
                                                      Radius.circular(15)),
                                              image: DecorationImage(
                                                  fit: BoxFit.fitWidth,
                                                  image: NetworkImage(snapshot.data!.data![index].primaryImage.toString()))),
                                          child: Align(
                                            alignment: Alignment.bottomRight,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.green.shade400,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(4.0),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                        snapshot.data!
                                                            .data![index].rating
                                                            .toString(),
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      Icon(
                                                        Icons.star,
                                                        color: Colors.white,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    snapshot
                                                        .data!.data![index].name
                                                        .toString(),
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                     const Icon(
                                                        Icons.discount,
                                                        color: Colors.red,
                                                      ),
                                                      Text(snapshot.data!.data![index].discount.toString() + "% FLAT OFF",
                                                        style: TextStyle(color: Colors.red,
                                                            fontWeight: FontWeight.w600),
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text('.' + snapshot.data!.data![index].tags.toString(),
                                                    style: TextStyle(fontWeight: FontWeight.w400),
                                                  ),
                                                  Text(snapshot.data!.data![index].distance.toString() +"KM")
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              return Container();
                            }
                          });
                    } else {
                      return Text('Loading');
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.red,
          child: const Icon(Icons.camera_rounded, color: Colors.white,
          ),
          onPressed: () {},
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        resizeToAvoidBottomInset: false, // avoid flotting action moving upword
        bottomNavigationBar: CustomBottamNavigationBar(),
      ),
    );
  }
}


