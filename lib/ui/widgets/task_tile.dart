import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo/ui/size_config.dart';
import 'package:todo/ui/theme.dart';
import '../../controllers/task_controller.dart';
import '../../models/task.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:share_plus/share_plus.dart';

class TaskTile extends StatelessWidget {
  TaskTile(this.task, {super.key});

  final Task task;
  final TaskController _taskController = Get.put(TaskController());

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        // color: _getBGClr(task.color),
      ),
      child: Slidable(
        key: const ValueKey(0),
        endActionPane: ActionPane(
           //dismissible: DismissiblePane(onDismissed: ()=>_deleteTaskSlide(context),),
          motion: const StretchMotion(),
          children: [
            SlidableAction(
              borderRadius: BorderRadius.circular(15),
              onPressed: _shareTo,
              backgroundColor: const Color(0xFF21B7CA),
              foregroundColor: Colors.white,
              icon: Icons.share,
              label: 'Share',
              spacing: 10,
            ),
            SlidableAction(
              autoClose: true,
              onPressed: _deleteTaskSlide,
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
              borderRadius: BorderRadius.circular(15),
              spacing: 10,
            ),
          ],
        ),
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(
            SizeConfig.orientation == Orientation.landscape ? 4 : 8,
          )),
          width: SizeConfig.orientation == Orientation.landscape
              ? SizeConfig.screenWidth / 2
              : SizeConfig.screenWidth,
          margin: EdgeInsets.only(bottom: getProportionateScreenHeight(12)),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: _getBGClr(task.color),
            ),
            child: Row(
              children: [
                Expanded(
                    child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title!,
                        style: GoogleFonts.lato(
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.access_time_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            '${task.startTime} - ${task.endTime}',
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[100],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        task.note!,
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[100],
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  height: 60,
                  width: 0.5,
                  color: Colors.grey[200]!.withOpacity(0.7),
                ),
                RotatedBox(
                  quarterTurns: 3,
                  child: Text(
                    task.isComplete == 0 ? 'Todo' : 'Completed',
                    style: GoogleFonts.lato(
                        textStyle: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    )),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _getBGClr(int? color) {
    switch (color) {
      case 0:
        return bluishClr;
      case 1:
        return orangeClr;
      case 2:
        return pinkClr;
      default:
        return bluishClr;
    }
  }

  void _deleteTaskSlide(BuildContext context) {
    _taskController.deleteTask(task);
  }
  void _shareTo(BuildContext context){
    Share.share('${task.title!}\nNote is : ${task.note}',subject: "Share note");
  }
}
