import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:todo/models/task.dart';
import 'package:todo/services/notification_services.dart';
import 'package:todo/services/theme_services.dart';
import 'package:todo/ui/pages/about.dart';
import 'package:todo/ui/pages/add_task_page.dart';
import 'package:todo/ui/size_config.dart';
import 'package:todo/ui/widgets/button.dart';
import 'package:todo/ui/widgets/task_tile.dart';
import '../../controllers/task_controller.dart';
import '../theme.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TaskController _taskController = Get.put(TaskController());
  DateTime _selectedDate = DateTime.now();
  late NotifyHelper notifiHelper;

  @override
  void initState() {
    super.initState();
    notifiHelper = NotifyHelper();
    notifiHelper.requestIOSPermissions();
    notifiHelper.initializeNotification();
    _taskController.getTask();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        backgroundColor: context.theme.colorScheme.background,
        appBar: _myAppBar(context),
        body: Column(
          children: [
            _addTaskBar(),
            _addDateBar(),
            const SizedBox(height: 20),
            _showTask(),
          ],
        ));
  }

  AppBar _myAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        onPressed: () {
          ThemeServices().switchTheme();
          // notifiHelper.displayNotification(
          //     title: "Them e Changed",
          //     body: 'The Theme is changer between dark and light ');
          // notifiHelper.scheduledNotification();
        },
        icon: Icon(
          Get.isDarkMode
              ? Icons.wb_sunny_outlined
              : Icons.nightlight_round_outlined,
          size: 24,
          color: Get.isDarkMode ? Colors.white : primaryClr,
        ),
      ),
      elevation: 0,
      backgroundColor: context.theme.colorScheme.background,
      actions: [
         InkWell(
          onTap: ()=>Get.to(const AboutScreen()),
          child: const CircleAvatar(
            backgroundImage: AssetImage("images/person.jpeg"),
            radius: 18,
          ),
        ),
        const SizedBox(
          width: 5,
        ),
        IconButton(
          onPressed: () {
            //  _taskController.deleteAllTask();
            _showDialogDelete();
          },
          icon: const Icon(
            Icons.delete_forever,
            color: Colors.red,
          ),
          tooltip: "Delete All data!",
        ),
        const SizedBox(
          width: 20,
        )
      ],
    );
  }

  // create function to refresh data and type future
  Future<void> _onRefresh() async {
    _taskController.getTask();
  }

  _showTask() {
    // to show task saved in database
    return Expanded(
      child: Obx(
        () {
          if (_taskController.taskList.isEmpty) {
            return _noTaskMsg();
          } else {
            return RefreshIndicator(
              onRefresh: _onRefresh,
              child: ListView.builder(
                scrollDirection: SizeConfig.orientation == Orientation.landscape
                    ? Axis.horizontal
                    : Axis.vertical,
                itemBuilder: (BuildContext context, int index) {
                  var task = _taskController.taskList[index];
                  if (task.repeat == 'Daily' ||
                      task.date == DateFormat.yMd().format(_selectedDate) ||
                      // check the difference between 2 day
                      // and check the result ara accept divide by 7
                      // this function will make me show just the time
                      // is modulation with 7 equal 0
                      (task.repeat == 'Weekly' &&
                          _selectedDate
                                      .difference(
                                          DateFormat.yMd().parse(task.date!))
                                      .inDays %
                                  7 ==
                              0) ||
                      // repeat the task every day in month is equal selected date
                      // without check years or month number
                      (task.repeat == 'Monthly' &&
                          DateFormat.yMd().parse(task.date!).day ==
                              _selectedDate.day)) {
                    var date = DateFormat.jm().parse(task.startTime!);
                    var myTime = DateFormat('HH:mm').format(date);

                    notifiHelper.scheduledNotification(
                      int.parse(myTime.toString().split(':')[0]),
                      int.parse(myTime.toString().split(':')[1]),
                      task,
                    );
                    return AnimationConfiguration.staggeredList(
                      duration: const Duration(milliseconds: 500),
                      position: index,
                      child: SlideAnimation(
                        horizontalOffset: 300,
                        child: GestureDetector(
                          onTap: () => _showBottomSheet(context, task),
                          child: TaskTile(task),
                        ),
                      ),
                    );
                  } else {
                    return Container();
                  }
                },
                itemCount: _taskController.taskList.length,
              ),
            );
          }
        },
      ),
    );
  }

  _addTaskBar() {
    // this the first part in screen  its have the date of this day and
    // button make me go to add task screen but make it function sync
    // the process wait the user to add the task get task that saved in database
    return Container(
      margin: const EdgeInsets.only(right: 20, left: 10, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat.yMMMMd().format(DateTime.now()),
                style: subHeadingStyle,
              ),
              Text(
                "Today",
                style: headingStyle,
              )
            ],
          ),
          MyButton(
              label: '+ Add Task',
              onTap: () async {
                await Get.to(const AddTaskPage());
                _taskController.getTask();
              }),
        ],
      ),
    );
  }

  _addDateBar() {
    // call library called dataPicker to show the date in second section
    //this library can customized *read the documentation
    return Container(
      margin: const EdgeInsets.only(top: 8, left: 20),
      child: DatePicker(
        DateTime.now(),
        height: 100,
        width: 60,
        selectedTextColor: Colors.white,
        selectionColor: primaryClr,
        initialSelectedDate: DateTime.now(),
        monthTextStyle: GoogleFonts.lato(
            textStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        )),
        dateTextStyle: GoogleFonts.lato(
            textStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 30,
          fontWeight: FontWeight.bold,
        )),
        dayTextStyle: GoogleFonts.lato(
            textStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        )),
        onDateChange: (newDate) {
          setState(() {
            _selectedDate = newDate;
          });
        },
      ),
    );
  }

  _noTaskMsg() {
    // this function show some information if task is empty
    // here i use orientation check value to customize the screen
    // in landscape or portrait
    // i use wrap because its allow me to control direction of content
    // such as rows and column but in one code
    return Stack(
      children: [
        AnimatedPositioned(
          duration: const Duration(microseconds: 2000),
          child: RefreshIndicator(
            onRefresh: _onRefresh,
            child: SingleChildScrollView(
              child: Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                direction: SizeConfig.orientation == Orientation.landscape
                    ? Axis.horizontal
                    : Axis.vertical,
                children: [
                  SizeConfig.orientation == Orientation.landscape
                      ? const SizedBox(height: 6)
                      : const SizedBox(height: 220),
                  SvgPicture.asset(
                    'images/task.svg',
                    height: 90,
                    semanticsLabel: 'tas',
                    color: primaryClr.withOpacity(0.5),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 10),
                    child: Text(
                      'Yoy don\'t have any note yet ! \nAdd new task to make your day mora Active ',
                      style: subTitleStyle,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizeConfig.orientation == Orientation.landscape
                      ? const SizedBox(height: 120)
                      : const SizedBox(height: 180),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  _showBottomSheet(BuildContext context, Task task) {
    Get.bottomSheet(SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.only(top: 4),
        height: (SizeConfig.orientation == Orientation.landscape)
            ? (task.isComplete == 1
                ? SizeConfig.screenHeight * 0.6
                : SizeConfig.screenHeight * 0.8)
            : (task.isComplete == 1
                ? SizeConfig.screenHeight * 0.30
                : SizeConfig.screenHeight * 0.39),
        width: SizeConfig.screenWidth,
        color: Get.isDarkMode ? darkHeaderClr : Colors.white,
        child: Column(
          children: [
            Flexible(
              child: Container(
                height: 6,
                width: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Get.isDarkMode ? Colors.grey[600] : Colors.grey[300],
                ),
              ),
            ),
            const SizedBox(height: 20),
            task.isComplete == 1
                ? Container()
                : _buildBottomSheet(
                    label: "Task Completed",
                    onTap: () {
                      _taskController.markTaskCompleted(task.id!);
                      notifiHelper.cancelNotification(task);
                      Get.back();
                    },
                    clr: primaryClr),
            _buildBottomSheet(
                label: "Delete Task",
                onTap: () {
                  _taskController.deleteTask(task);
                  notifiHelper.cancelNotification(task);
                  Get.back();
                },
                clr: Colors.redAccent),
            Divider(
              color: Get.isDarkMode ? Colors.grey : darkGreyClr,
            ),
            _buildBottomSheet(
                label: "Cancel ",
                onTap: () {
                  Get.back();
                },
                clr: primaryClr),
            const SizedBox(height: 20),
          ],
        ),
      ),
    ));
  }

  _buildBottomSheet(
      {required String label,
      required Function() onTap,
      required Color clr,
      bool isClose = false}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 60,
        width: SizeConfig.screenWidth * 0.9,
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: isClose
                ? Get.isDarkMode
                    ? Colors.grey[600]!
                    : Colors.grey[300]!
                : clr,
          ),
          borderRadius: BorderRadius.circular(20),
          color: isClose ? Colors.transparent : clr,
        ),
        child: Center(
          child: Text(
            label,
            style:
                isClose ? titleStyle : titleStyle.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Future _showDialogDelete() {
    return Get.defaultDialog(
        title: 'Alert',
        cancel: TextButton(
            onPressed: () => Get.back(),
            child: Text(
              "Cancel ",
              style: body2Style.copyWith(color: Colors.red),
            )),
        confirm: TextButton(
            onPressed: () {
              notifiHelper.cancelAllNotification();
              _taskController.deleteAllTask();
              Get.back();
              showToast('Tasks Cleared!');
            },
            child: Text(
              "OK ",
              style: body2Style.copyWith(color: primaryClr),
            )),
        middleText: "Are You Sure to Delete All Task ?");
  }

  void showToast(String msg) {
    FToast().init(context);
    FToast().showToast(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25.0),
            //color: Colors.greenAccent,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle,color: Colors.greenAccent,),
              const SizedBox(
                width: 12.0,
              ),
              Text(msg),
            ],
          ),
        ),
        toastDuration: const Duration(seconds: 3),
    );
  }
}
