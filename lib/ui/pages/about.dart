import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../theme.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: context.theme.colorScheme.background,
        appBar: _myAppBar(context),
        body: SingleChildScrollView(
          child: Center(
              child: MediaQuery.of(context).orientation == Orientation.portrait
                  ? _buildPortrait(context)
                  : _buildLandScape(context)),
        ));
  }

  Widget _buildPortrait(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            CircleAvatar(
              radius: 150,
              backgroundColor: context.theme.colorScheme.background,
              child: Image.asset(
                'images/logo.png',
                color: Get.isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            Text(
              "To Do...",
              style: headingStyle,
            ),
            Text(
              "1.0.0",
              style: titleStyle,
            ),
            Text(
              "Management your Nice Active Day",
              style: titleStyle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              '© 2023  البرمجة',
              style: body2Style,
            ),
          ],
        ),
        const Divider(color: Colors.grey, thickness: 1.2, indent: 5),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'This program was created by\nMuhammad Ali\nOne of the programmers on\nbarmaja FB \nHassan Fleih course\non the Udemy\nThe code can be found on :',
              textAlign: TextAlign.center,
              style: titleStyle,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => _launchURL(
                      userUrl:
                          'https://github.com/muhammadali224?tab=projects'),
                  child: CircleAvatar(
                    radius: 30,
                    backgroundColor: context.theme.colorScheme.background,
                    child: Image.asset(
                      'images/gitlogo.png',
                      color: Get.isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => _launchURL(
                      userUrl: 'https://web.facebook.com/arabicoderspage'),
                  child: CircleAvatar(
                    radius: 63,
                    backgroundColor: context.theme.colorScheme.background,
                    child: Image.asset(
                      'images/fblogo.png',

                      // color:Get.isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => _mailTo(),
                  child: CircleAvatar(
                    radius: 33,
                    backgroundColor: context.theme.colorScheme.background,
                    child: Image.asset(
                      'images/emaillogo.png',
                      color: Get.isDarkMode ? Colors.white : Colors.black,

                      // color:Get.isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLandScape(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            CircleAvatar(
              radius: 95,
              backgroundColor: context.theme.colorScheme.background,
              child: Image.asset(
                'images/logo.png',
                color: Get.isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            Text(
              "To Do...",
              style: headingStyle,
            ),
            Text(
              "1.0.0",
              style: titleStyle,
            ),
            Text(
              "Management your Nice Active Day",
              style: titleStyle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              '© 2023  البرمجة',
              style: body2Style,
            ),
          ],
        ),
        Column(
          children: [
            Column(
              children: [
                Text(
                  'This program was created by\nMuhammad Ali\nOne of the programmers on\nbarmaja FB \nHassan Fleih course\non the Udemy\nThe code can be found on :',
                  textAlign: TextAlign.center,
                  style: titleStyle,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => _launchURL(
                          userUrl:
                              'https://github.com/muhammadali224?tab=projects'),
                      child: CircleAvatar(
                        radius: 30,
                        backgroundColor: context.theme.colorScheme.background,
                        child: Image.asset(
                          'images/gitlogo.png',
                          color: Get.isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _launchURL(
                          userUrl: 'https://web.facebook.com/arabicoderspage'),
                      child: CircleAvatar(
                        radius: 63,
                        backgroundColor: context.theme.colorScheme.background,
                        child: Image.asset(
                          'images/fblogo.png',

                          // color:Get.isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _mailTo(),
                      child: CircleAvatar(
                        radius: 33,
                        backgroundColor: context.theme.colorScheme.background,
                        child: Image.asset(
                          'images/emaillogo.png',
                          color: Get.isDarkMode ? Colors.white : Colors.black,

                          // color:Get.isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  AppBar _myAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        "About",
        style: headingStyle.copyWith(fontSize: 40),
      ),
      leading: IconButton(
        onPressed: () => Get.back(),
        icon: const Icon(
          Icons.arrow_back_ios,
          color: primaryClr,
        ),
      ),
      elevation: 0,
      backgroundColor: context.theme.colorScheme.background,
    );
  }

  _launchURL({required String userUrl}) async {
    final uri = Uri.parse(userUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $userUrl';
    }
  }

  Future<void> _mailTo() async {
    final Uri param = Uri(
        scheme: 'mailto',
        path: 'muhammad.alfaqoui@gmail.com',
        queryParameters: {
          'subject': 'ToDo',
        });
    String url = param.toString();
    if (await canLaunchUrlString(url)) {
      await launch(url);
    } else {
      print('Could not launch $url');
    }
  }
}
