import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel/data/model/response/favorit_model.dart';
import 'package:travel/provider/Kategori_provider.dart';
import 'package:travel/provider/auth_provider.dart';
import 'package:travel/provider/favorit_provider.dart';
import 'package:travel/provider/lokasi_provider.dart';
import 'package:travel/utill/styles.dart';
import 'package:travel/view/base/custom_login_field.dart';
import 'package:sizer/sizer.dart';
import 'package:travel/view/base/custom_snackbar.dart';
import 'package:travel/view/screens/login_screen_email.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  GlobalKey<ScaffoldMessengerState> _globalKey = GlobalKey();
  TextEditingController _umurController = TextEditingController();
  TextEditingController _lokasiController = TextEditingController();
  TextEditingController _kategoriController = TextEditingController();
  FavoritModel data;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _umurController.dispose();
    _lokasiController.dispose();
    _kategoriController.dispose();
    super.dispose();
  }

  void _loadData() async {
    // melakukan inisialisasi data favorit user
    await Provider.of<FavoritProvider>(context, listen: false).getFavorit();
    var data =
        await Provider.of<FavoritProvider>(context, listen: false).favoritList;

    if (data != null) {
      data as FavoritModel;
      _umurController..text = data.umur.toString();
      _lokasiController..text = data.lokasi;
      _kategoriController..text = data.kategori;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _globalKey,
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(10, 40, 10, 10),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/image/home_bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Consumer<FavoritProvider>(
          builder: (context, favoritProvider, child) {
            return (favoritProvider.isLoading)
                ? Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.white,
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        child: Column(
                          children: [
                            CustomLoginField(
                              hintText: 'Umur',
                              controller: _umurController,
                              inputType: TextInputType.number,
                              inputAction: TextInputAction.done,
                            ),
                            SizedBox(height: 10),
                            CustomLoginField(
                              hintText: 'Lokasi',
                              readOnly: true,
                              controller: _lokasiController,
                              isShowSuffixIcon: true,
                              isIcon: true,
                              suffixIcon: Icons.arrow_drop_down,
                              onTap: () async {
                                await showModalBottomSheet(
                                  context: context,
                                  builder: (_) {
                                    Provider.of<LokasiProvider>(context,
                                            listen: false)
                                        .getLokasiList(false);
                                    return Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10),
                                      child: Consumer<LokasiProvider>(
                                        builder:
                                            (context, lokasiProvider, child) {
                                          return ListView.separated(
                                            shrinkWrap: true,
                                            separatorBuilder:
                                                (context, index) => Divider(),
                                            itemCount:
                                                (lokasiProvider.isLoading)
                                                    ? 1
                                                    : lokasiProvider
                                                        .lokasiList.length,
                                            itemBuilder: (context, index) {
                                              return (lokasiProvider.isLoading)
                                                  ? Center(
                                                      child:
                                                          CircularProgressIndicator(
                                                        backgroundColor:Colors.white,
                                                      ),
                                                    )
                                                  : InkWell(
                                                      onTap: () {
                                                        setState(
                                                          () {
                                                            _lokasiController
                                                                    .text =
                                                                lokasiProvider
                                                                    .lokasiList[
                                                                        index]
                                                                    .lokasi;
                                                          },
                                                        );
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text(
                                                        lokasiProvider
                                                            .lokasiList[index]
                                                            .lokasi,
                                                        style: rockSaltMedium
                                                            .copyWith(
                                                          fontSize: 18.sp,
                                                        ),
                                                      ),
                                                    );
                                            },
                                          );
                                        },
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Wich one you prefer',
                              textAlign: TextAlign.left,
                              style: rockSaltMedium.copyWith(
                                fontSize: 24,
                              ),
                            ),
                            SizedBox(height: 10),
                            CustomLoginField(
                              hintText: 'Kategori',
                              readOnly: true,
                              controller: _kategoriController,
                              isShowSuffixIcon: true,
                              isIcon: true,
                              suffixIcon: Icons.arrow_drop_down,
                              onTap: () async {
                                await showModalBottomSheet(
                                  context: context,
                                  builder: (_) {
                                    Provider.of<KategoriProvider>(context,
                                            listen: false)
                                        .getKategoriList(false);
                                    return Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10),
                                      child: Consumer<KategoriProvider>(
                                        builder:
                                            (context, kategoriProvider, child) {
                                          return ListView.separated(
                                            shrinkWrap: true,
                                            separatorBuilder:
                                                (context, index) => Divider(),
                                            itemCount:
                                                (kategoriProvider.isLoading)
                                                    ? 1
                                                    : kategoriProvider
                                                        .kategoriList.length,
                                            itemBuilder: (context, index) {
                                              return (kategoriProvider
                                                      .isLoading)
                                                  ? Center(
                                                      child:
                                                          CircularProgressIndicator(
                                                        backgroundColor:Colors.white,
                                                      ),
                                                    )
                                                  : InkWell(
                                                      onTap: () {
                                                        Navigator.pop(context);
                                                        setState(
                                                          () {
                                                            _kategoriController
                                                              ..text =
                                                                  kategoriProvider
                                                                      .kategoriList[
                                                                          index]
                                                                      .kategori;
                                                          },
                                                        );
                                                      },
                                                      child: Text(
                                                        kategoriProvider
                                                            .kategoriList[index]
                                                            .kategori,
                                                        style: rockSaltMedium
                                                            .copyWith(
                                                          fontSize: 18.sp,
                                                        ),
                                                      ),
                                                    );
                                            },
                                          );
                                        },
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 40),
                      InkWell(
                        onTap: () async {
                          // inisialisasi data yang aka dikirim
                          Map<String, dynamic> data = {
                            "umur": _umurController.text,
                            "lokasi": _lokasiController.text,
                            "kategori": _kategoriController.text
                          };

                          await Provider.of<FavoritProvider>(context,
                                  listen: false)
                              .updateFavorit(data)
                              .then((value) {
                            // menampilkan message setelah melakukan update data favorit
                            if (value.isSuccess) {
                              showCustomSnackBar(
                                  'Data berhasil disimpan', context,
                                  isError: false);
                            }
                            // menampilkan message setelah gagal melakukan update data favorit
                            else {
                              showCustomSnackBar(
                                  'Data gagal disimpan', context);
                            }
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 5, bottom: 5),
                          padding:
                              EdgeInsets.symmetric(horizontal: 25, vertical: 0),
                          decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.circular(20)),
                          child: Text(
                            'Update',
                            style: rockSaltMedium.copyWith(
                              fontSize: 18.sp,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          // memanggil fungsi logout
                          await Provider.of<AuthProvider>(context,
                                  listen: false)
                              .logout()
                              .then((value) {
                            // menampilkan halaman login setelah logout
                            if (value) {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginScreenEmail(),
                                ),
                                (route) => false,
                              );
                            }
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 5, bottom: 30),
                          padding:
                              EdgeInsets.symmetric(horizontal: 25, vertical: 0),
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(20)),
                          child: Text(
                            'Sign Out',
                            style: rockSaltMedium.copyWith(
                              fontSize: 18.sp,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
          },
        ),
      ),
    );
  }
}
