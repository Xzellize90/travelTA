import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:travel/data/model/response/content_model.dart';
import 'package:travel/provider/like_provider.dart';
import 'package:travel/utill/styles.dart';

class ViewContent extends StatefulWidget {
  final ContentModel contentModel;
  ViewContent({Key key, @required this.contentModel}) : super(key: key);

  @override
  State<ViewContent> createState() => _ViewContentState();
}

class _ViewContentState extends State<ViewContent> {
  GlobalKey<ScaffoldMessengerState> _globalKey = GlobalKey();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  @override
  void initState() {
    super.initState();
    loadData();
    // marker pada map berdasrkan index data yang dipilih
    final Marker marker = Marker(
      markerId: MarkerId('lokasi'),
      position: LatLng(
        double.parse(widget.contentModel.latitude),
        double.parse(widget.contentModel.longitude),
      ),
    );
    markers[MarkerId('lokasi')] = marker;
  }

  Future<void> loadData() async {
    // pengeckan status like
    await Provider.of<LikeProvider>(context, listen: false)
        .getLike(int.parse(widget.contentModel.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _globalKey,
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/image/home_bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          width: double.infinity,
          child: Column(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.fromLTRB(10, 40, 10, 10),
                    color: Colors.orange,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        InkWell(
                          onTap: () async {
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 8),
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(20)),
                            child: Text(
                              'Back',
                              style: rockSaltMedium.copyWith(
                                fontSize: 16.sp,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            widget.contentModel.judul,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: rockSaltMedium.copyWith(
                              fontSize: 16.sp,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Consumer<LikeProvider>(
                          builder: (context, likeProvider, child) {
                            Color color = Colors.grey;
                            if (likeProvider.success) {
                              color = Colors.red;
                            }

                            return InkWell(
                              onTap: () async {
                                // pemanggilan fungsi like
                                likeProvider
                                    .updateLike(
                                        int.parse(widget.contentModel.id))
                                    .then(
                                      (value) => likeProvider.getLike(
                                          int.parse(widget.contentModel.id)),
                                    );
                              },
                              child: Icon(
                                Icons.favorite,
                                size: 30.sp,
                                color: color,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.network(
                          widget.contentModel.foto,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Kategori : ${widget.contentModel.kategori}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: rockSaltMedium.copyWith(
                            fontSize: 18.sp,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Lokasi : ${widget.contentModel.lokasi}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: rockSaltMedium.copyWith(
                            fontSize: 18.sp,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Batas Umur : ${widget.contentModel.batasUmur} th',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: rockSaltMedium.copyWith(
                            fontSize: 18.sp,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Alamat : ${widget.contentModel.alamat}',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: rockSaltMedium.copyWith(
                            fontSize: 18.sp,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Jam Buka : ${widget.contentModel.jamBuka}',
                          style: rockSaltMedium.copyWith(
                            fontSize: 18.sp,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          widget.contentModel.deskripsi,
                          style: rockSaltMedium.copyWith(
                            fontSize: 18.sp,
                          ),
                        ),
                        SizedBox(height: 20),
                        Center(
                          child: Container(
                            width: 350,
                            height: 350,
                            child: GoogleMap(
                              mapType: MapType.normal,
                              initialCameraPosition: CameraPosition(
                                target: LatLng(
                                  double.parse(widget.contentModel.latitude),
                                  double.parse(widget.contentModel.longitude),
                                ),
                                zoom: 14.0,
                              ),
                              markers: Set<Marker>.of(markers.values),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
