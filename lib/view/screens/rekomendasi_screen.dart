import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel/provider/content_provider.dart';
import 'package:travel/provider/rekomendasi_provider.dart';
import 'package:travel/utill/styles.dart';
import 'package:travel/view/base/custom_login_field.dart';
import 'package:sizer/sizer.dart';
import 'package:travel/view/screens/view_content.dart';

class RekomendasiScreen extends StatefulWidget {
  RekomendasiScreen({Key key}) : super(key: key);

  @override
  State<RekomendasiScreen> createState() => _RekomendasiScreenState();
}

class _RekomendasiScreenState extends State<RekomendasiScreen> {
  GlobalKey<ScaffoldMessengerState> _globalKey = GlobalKey();
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadData() async {
    Provider.of<RekomendasiProvider>(context, listen: false)
        .getContentList(false, _searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    _loadData();
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
                        Expanded(
                          child: CustomLoginField(
                            hintText: 'Search',
                            inputAction: TextInputAction.done,
                            controller: _searchController,
                            onSubmit: (value) {
                              Provider.of<ContentProvider>(context,
                                      listen: false)
                                  .getContentList(false, value.toString());
                            },
                          ),
                        ),
                        SizedBox(width: 10),
                        InkWell(
                          onTap: () async {
                            Provider.of<ContentProvider>(context, listen: false)
                                .getContentList(false, _searchController.text);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 8),
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(20)),
                            child: Text(
                              'Search',
                              style: rockSaltMedium.copyWith(
                                fontSize: 16.sp,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.fromLTRB(
                      0, 0, 0, MediaQuery.of(context).size.height * 10 / 100),
                  child: Consumer<RekomendasiProvider>(
                    builder: (context, rekomendasiProvider, child) {
                      return (rekomendasiProvider.isLoading)
                          ? Center(
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.white,
                              ),
                            )
                          : (rekomendasiProvider.contentList.length > 0)
                              ? ListView.builder(
                                  itemCount:
                                      rekomendasiProvider.contentList.length,
                                  padding: EdgeInsets.only(top: 10),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return ViewContent(
                                                  contentModel:
                                                      rekomendasiProvider
                                                          .contentList[index]);
                                            },
                                          ),
                                        );
                                      },
                                      child: Container(
                                        margin:
                                            EdgeInsets.fromLTRB(10, 0, 10, 10),
                                        color: Colors.orange,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              height: 80,
                                              width: 80,
                                              child: Image.network(
                                                rekomendasiProvider
                                                    .contentList[index].foto,
                                                height: 80,
                                                width: 80,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10),
                                                child: Text(
                                                  rekomendasiProvider
                                                      .contentList[index].judul,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style:
                                                      rockSaltMedium.copyWith(
                                                    fontSize: 18.sp,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                )
                              : Center(
                                  child: Text(
                                    'Tolong Isi Profile Dulu',
                                    style: rockSaltMedium.copyWith(
                                      fontSize: 18,
                                    ),
                                  ),
                                );
                    },
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
