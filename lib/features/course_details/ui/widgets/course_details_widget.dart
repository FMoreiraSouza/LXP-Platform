import 'package:flutter/material.dart';
import 'package:lxp_platform/core/ui/states/app_load_widget.dart';
import 'package:lxp_platform/core/utils/enums/flow_state.dart';
import 'package:lxp_platform/features/course_details/controllers/course_details_controller.dart';
import 'package:lxp_platform/features/course_details/ui/widgets/course_content_widget.dart';

class CourseDetailsWidget extends StatefulWidget {
  final CourseDetailsController controller;

  const CourseDetailsWidget({super.key, required this.controller});

  @override
  State<CourseDetailsWidget> createState() => _CourseDetailsWidgetState();
}

class _CourseDetailsWidgetState extends State<CourseDetailsWidget> {
  bool _isDialogShowing = false;
  bool favoritesChanged = false;

  void _onFavoriteChanged() {
    setState(() {
      favoritesChanged = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: AnimatedBuilder(
        animation: widget.controller,
        builder: (context, _) {
          if (widget.controller.isLoading) {
            _isDialogShowing = false;
            return const AppLoadWidget(label: 'Carregando curso');
          } else if (widget.controller.errorState != null && !_isDialogShowing) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _showErrorDialog(context, widget.controller.errorState!);
              _isDialogShowing = true;
            });
            return const SizedBox.shrink();
          } else if (widget.controller.courseDetails == null) {
            _isDialogShowing = false;
            return const Center(child: Text('Curso não encontrado'));
          } else {
            _isDialogShowing = false;
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: CourseContentWidget(
                    courseDetails: widget.controller.courseDetails!,
                    controller: widget.controller,
                    onFavoriteChanged: _onFavoriteChanged,
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  void _showErrorDialog(BuildContext context, FlowState errorState) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E1E1E),
          title: Text(
            errorState == FlowState.noConnection ? "Sem conexão" : "Erro ao carregar",
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
          ),
          content: Text(
            errorState == FlowState.noConnection
                ? "Verifique sua conexão com a internet."
                : "Ocorreu um erro desconhecido ao tentar carregar o curso.",
            style: const TextStyle(color: Colors.grey, fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _isDialogShowing = false;
                widget.controller.loadCourseDetails();
              },
              child: const Text(
                "Tentar novamente",
                style: TextStyle(color: Color(0xFF4A90E2), fontWeight: FontWeight.bold),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _isDialogShowing = false;
                Navigator.of(context).pop({'favoritesChanged': favoritesChanged});
              },
              child: const Text(
                "Voltar",
                style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }
}
