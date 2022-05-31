import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:travel/provider/content_provider.dart';
import 'package:travel/utill/styles.dart';
import 'package:travel/view/base/custom_login_field.dart';
import 'package:travel/view/screens/view_content.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
    Provider.of<ContentProvider>(context, listen: false)
        .getContentList(false, _searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    // memamnggil fungsi load data untuk melakukan fetchinga data
    // dari endpoint
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
                              // memanggil fungsi pencarian data
                              // apabila melakukan submit dari text input
                              Provider.of<ContentProvider>(context,
                                      listen: false)
                                  .getContentList(false, value.toString());
                            },
                          ),
                        ),
                        SizedBox(width: 10),
                        InkWell(
                          onTap: () async {
                            // memanggil fungsi pencarian data
                            // apabila melakukan submit dari tombol search
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
                  child: Consumer<ContentProvider>(
                    builder: (context, contentProvider, child) {
                      return (contentProvider.isLoading)
                          // fungsi preloaded data
                          ? Center(
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.white,
                              ),
                            )
                          // Menampilkan data kedalam list
                          : ListView.builder(
                              itemCount: contentProvider.contentList.length,
                              padding: EdgeInsets.only(top: 10),
                              itemBuilder: (BuildContext context, int index) {
                                return InkWell(
                                  onTap: () {
                                    // melihat detail content berdasarkan
                                    // index data
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return ViewContent(
                                              contentModel: contentProvider
                                                  .contentList[index]);
                                        },
                                      ),
                                    );
                                  },
                                  child: Container(
                                    margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                                    color: Colors.orange,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: 80,
                                          width: 80,
                                          child: Image.network(
                                            contentProvider
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
                                              contentProvider
                                                  .contentList[index].judul,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: rockSaltMedium.copyWith(
                                                fontSize: 18.sp,
                                                color:
                                                    Colors.white,
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
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
