import 'package:flutter/material.dart';
import 'package:lxp_platform/features/course_details/controllers/course_details_controller.dart';
import 'package:lxp_platform/features/course_details/ui/widgets/course_details_widget.dart';

// Widget principal
class CourseDetailsPage extends StatefulWidget {
  final CourseDetailsController controller;

  const CourseDetailsPage({super.key, required this.controller});

  @override
  State<CourseDetailsPage> createState() => _CourseDetailsPageState();
}

class _CourseDetailsPageState extends State<CourseDetailsPage> {
  @override
  void initState() {
    super.initState();
    widget.controller.loadCourseDetails();
  }

  @override
  Widget build(BuildContext context) {
    return CourseDetailsWidget(controller: widget.controller);
  }
}
