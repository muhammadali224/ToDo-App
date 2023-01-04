import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo/controllers/task_controller.dart';
import 'package:todo/ui/theme.dart';
import 'package:todo/ui/widgets/button.dart';
import 'package:todo/ui/widgets/input_field.dart';
import '../../models/task.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  TaskController _taskController = Get.put(TaskController());
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  DateTime _selectedData = DateTime.now();
  String _startTime = DateFormat('hh:mm a').format(DateTime.now()).toString();
  String _endTime = DateFormat('hh:mm a')
      .format(DateTime.now().add(const Duration(minutes: 15)))
      .toString();
  int _selectedRemind = 5;
  List<int> remindList = [5, 10, 15, 20];
  String _selectedRepeat = 'None';
  List<String> repeatList = ['None', 'Daily', 'Weekly', 'Monthly'];
  int _selectedColor = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: context.theme.colorScheme.background,
        appBar: _myAppBar(context),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  'Add Task',
                  style: headingStyle,
                ),
                InputField(
                  title: 'Title',
                  hint: 'Enter Title here',
                  controller: _titleController,
                ),
                InputField(
                  title: 'Note ',
                  hint: 'Enter Note here',
                  controller: _noteController,
                ),
                InputField(
                  title: 'Date',
                  // this data formatted by intl library
                  hint: DateFormat.yMd().format(_selectedData),
                  widget: IconButton(
                    onPressed: () => _getDateFromUser(),
                    icon: const Icon(
                      Icons.calendar_today_outlined,
                      color: Colors.grey,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: InputField(
                        title: 'Start Time',
                        hint: _startTime,
                        widget: IconButton(
                          onPressed: () => _getTimeFromUser(isStartTime: true),
                          icon: const Icon(
                            Icons.access_time_rounded,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: InputField(
                        title: 'End Time',
                        hint: _endTime,
                        widget: IconButton(
                          onPressed: () => _getTimeFromUser(isStartTime: false),
                          icon: const Icon(
                            Icons.access_time_rounded,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                InputField(
                  title: 'Remind',
                  hint: '$_selectedRemind minutes Early',
                  widget: Row(
                    children: [
                      // this widget make a list of item
                      // but items i save in list of string or integer
                      // for this reason i use mapping to extract item in list
                      // as list of widget
                      // make attention for data type what this function received
                      // here to example one to String list and another to Int list
                      DropdownButton(
                        items: remindList
                            .map<DropdownMenuItem<String>>(
                              (int value) => DropdownMenuItem(
                                value: value.toString(),
                                child: Text(
                                  '$value',
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                        icon: const Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.grey,
                        ),
                        iconSize: 30,
                        dropdownColor: Colors.blueGrey,
                        elevation: 4,
                        borderRadius: BorderRadius.circular(10),
                        underline: Container(
                          height: 0,
                        ),
                        style: subTitleStyle,
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedRemind = int.parse(newValue!);
                          });
                        },
                      ),
                      const SizedBox(width: 6)
                    ],
                  ),
                ),
                InputField(
                  title: 'Repeat',
                  hint: _selectedRepeat,
                  widget: Row(
                    children: [
                      DropdownButton(
                        items: repeatList
                            .map<DropdownMenuItem<String>>(
                              (value) => DropdownMenuItem(
                                value: value,
                                child: Text(
                                  value,
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                        icon: const Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.grey,
                        ),
                        iconSize: 30,
                        dropdownColor: Colors.blueGrey,
                        borderRadius: BorderRadius.circular(10),
                        elevation: 4,
                        underline: Container(
                          height: 0,
                        ),
                        style: subTitleStyle,
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedRepeat = newValue!;
                          });
                        },
                      ),
                      const SizedBox(width: 6)
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _colorPalette(),
                    MyButton(
                      label: 'Create Task',
                      onTap: () {
                        _validateDate();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  _validateDate() {
    if (_titleController.text.isNotEmpty && _noteController.text.isNotEmpty) {
      _addTaskToDB();
      Get.back();
    } else if (_titleController.text.isEmpty || _noteController.text.isEmpty) {
      Get.snackbar('Required', 'All Field are required',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.white,
          colorText: primaryClr,
          icon: const Icon(
            Icons.error_outline,
            color: Colors.red,
          ));
    }
  }

  _addTaskToDB() async {
    int value = await _taskController.addTask(
      task: Task(
        title: _titleController.text,
        note: _noteController.text,
        isComplete: 0,
        date: DateFormat.yMd().format(_selectedData),
        startTime: _startTime,
        endTime: _endTime,
        color: _selectedColor,
        remind: _selectedRemind,
        repeat: _selectedRepeat,
      ),
    );
  }

  AppBar _myAppBar(BuildContext context) {
    // Customized AppBar have a picture
    // and back button like ios System
    return AppBar(
      leading: IconButton(
        onPressed: () => Get.back(),
        icon: const Icon(
          Icons.arrow_back_ios,
          size: 24,
          color: primaryClr,
        ),
      ),
      elevation: 0,
      backgroundColor: context.theme.colorScheme.background,
      actions: const [
        CircleAvatar(
          backgroundImage: AssetImage("images/person.jpeg"),
          radius: 18,
        ),
        SizedBox(width: 20)
      ],
    );
  }

  Column _colorPalette() {
    // this Function return the 3 circle color in the bottom
    // i use CircleAvatar to make the color pattern circular
    // and put condition from index i generate from list of widget
    // this index allow me to check what user color pressed and put in
    // middle a small tick from icon
    return Column(
      crossAxisAlignment:CrossAxisAlignment.start,
      children: [
        Text(
          'Color',
          style: titleStyle,
        ),
        const SizedBox(
          height: 20,
        ),
        Wrap(
            children: List.generate(
          3,
          (index) => GestureDetector(
            onTap: () {
              setState(() {
                _selectedColor = index;
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: CircleAvatar(
                radius: 15,
                backgroundColor: index == 0
                    ? primaryClr
                    : index == 1
                        ? pinkClr
                        : orangeClr,
                child: _selectedColor == index
                    ? const Icon(
                        Icons.done,
                        size: 18,
                        color: Colors.white,
                      )
                    : null,
              ),
            ),
          ),
        ))
      ],
    );
  }

  _getDateFromUser() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedData,
      firstDate: DateTime(2015),
      lastDate: DateTime(2030),
    );
    pickedDate != null
        ? setState(() => _selectedData = pickedDate)
        : Get.snackbar('Required', 'Enter Valid Date',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.white,
            colorText: primaryClr,
            icon: const Icon(
              Icons.error_outline,
              color: Colors.red,
            ));
  }

  _getTimeFromUser({required bool isStartTime}) async {
    TimeOfDay? pickedTime = await showTimePicker(

      context: context,
      initialTime: isStartTime
          //set the start time and time
          // i don't use the variable declared because its type is string
          ? TimeOfDay.fromDateTime(DateTime.now())
          : TimeOfDay.fromDateTime(
              DateTime.now().add(const Duration(minutes: 15))),
    );
    String formattedDate = pickedTime!.format(context);

    if (isStartTime) {
      setState(() => _startTime = formattedDate);
    } else {
      setState(() => _endTime = formattedDate);
    }
  }
}
