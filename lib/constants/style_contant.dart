import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:presensi/constants/color_constant.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:presensi/constants/sp_icon.dart';
import 'package:presensi/constants/var_constant.dart';
import 'package:presensi/screens/home_screen.dart';

//style for title
var mTitleStyle = GoogleFonts.inter(
  fontWeight: FontWeight.w600,
  color: mTitleColor,
  fontSize: 16,
);

// Style for

//Style for petunjuk
var mServiceTitleStyle = GoogleFonts.inter(
  fontWeight: FontWeight.w500,
  fontSize: 12,
  color: mTitleColor,
);
var mServiceSubtitleStyle = GoogleFonts.inter(
  fontWeight: FontWeight.w400,
  fontSize: 10,
  color: mTitleColor,
);

var mDateStyle = GoogleFonts.inter(
  fontWeight: FontWeight.w600,
  fontSize: 16,
  color: mTitleColor,
);
var mTimeStyle = GoogleFonts.inter(
  fontWeight: FontWeight.bold,
  fontSize: 20,
  color: mTitleColor,
);

class TextFieldContainer extends StatelessWidget {
  final Widget child;
  const TextFieldContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      width: size.width * 1.0,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: Colors.black12,
        ),
      ),
      child: child,
    );
  }
}

class DetailItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String icon;
  final bool isLast;
  const DetailItem({
    super.key,
    required this.subtitle,
    required this.icon,
    required this.title,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 5.0,
                  offset: const Offset(0.0, 1)),
            ],
          ),
          child: ListTile(
            minLeadingWidth: 0,
            leading: SizedBox(
              height: double.infinity,
              child: SPIcon(assetName: icon),
            ),
            title: Text(
              title,
              style: const TextStyle(color: Colors.grey, fontSize: 15),
            ),
            subtitle: Text(
              subtitle,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ),
        ),
        // isLast ? Container() : const Divider()
      ],
    );
  }
}

class DetailItemWOIcon extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool img;

  final bool isLast;
  const DetailItemWOIcon({
    super.key,
    required this.subtitle,
    required this.title,
    required this.isLast,
    required this.img,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: mBluePu,
              )),
          child: ListTile(
            minLeadingWidth: 0,
            title: Text(
              title,
              style: const TextStyle(color: Colors.black87, fontSize: 15),
            ),
            subtitle: img
                ? Container(
                    margin: const EdgeInsets.only(top: 10),
                    alignment: Alignment.center,
                    child: Column(
                      children: <Widget>[
                        Stack(
                          children: <Widget>[
                            SizedBox(
                              height: 200,
                              width: 250,
                              child: subtitle == ''
                                  ? Image.asset(
                                      'assets/images/avatar.png',
                                      scale: 0.5,
                                    )
                                  : Image.network(
                                      '$apiServerF/storage/uploads/$subtitle',
                                      scale: 0.5,
                                    ),
                            )
                          ],
                        )
                      ],
                    ),
                  )
                : Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 17,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
        // isLast ? Container() : const Divider()
      ],
    );
  }
}

class DefaultButton extends StatelessWidget {
  const DefaultButton({super.key, required this.text, required this.press});
  final String text;
  final VoidCallback press;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      // height: getProportionateScreenHeight(56),
      height: 50,
      child: FloatingActionButton(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: mBluePu,
        splashColor: mBluePu,
        onPressed: press,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 15,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

void showBottomModal(BuildContext context, dynamic child, double height) {
  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    builder: (context) {
      return height == 0
          ? Container(
              height: height,
              color: const Color(0xFF737373),
              child: Container(
                child: child,
                decoration: const BoxDecoration(
                  color: mBackgroundColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
              ),
            )
          : Container(
              height: height,
              color: const Color(0xFF737373),
              child: Container(
                child: child,
                decoration: const BoxDecoration(
                  color: mBackgroundColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
              ),
            );
    },
  );
}

class DefaultCostumWidthButton extends StatelessWidget {
  const DefaultCostumWidthButton({
    super.key,
    required this.text,
    required this.press,
    required this.width,
    required this.color,
    required this.splashColor,
    required this.colorText,
  });
  final String text;
  final double width;
  final Color color;
  final Color colorText;
  final Color splashColor;
  final VoidCallback press;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: FloatingActionButton(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        backgroundColor: color,
        splashColor: splashColor,
        onPressed: press,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 14,
            color: colorText,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class ButtonDTP extends StatelessWidget {
  final IconButton child;
  const ButtonDTP({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: const ShapeDecoration(
        color: Colors.blue,
        shape: CircleBorder(),
      ),
      width: 38,
      height: 38,
      child: child,
    );
  }
}

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  void _onItemTapped(int index) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(
          changeOptions: index,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      decoration: BoxDecoration(
        color: mFillColor,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 15,
            offset: const Offset(0, 5),
          )
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/home.svg',
              height: 20,
            ),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/absen.svg',
              height: 20,
            ),
            label: 'Absen',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/user.svg',
              height: 20,
            ),
            label: 'Profil',
          ),
        ],
        selectedItemColor: Colors.black,
        backgroundColor: Colors.transparent,
        selectedFontSize: 12,
        showUnselectedLabels: true,
        elevation: 0,
        onTap: _onItemTapped,
      ),
    );
  }
}
