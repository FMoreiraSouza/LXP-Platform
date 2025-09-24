import 'package:flutter/material.dart';
import 'package:lxp_platform/core/constants/page_states.dart';
import 'package:lxp_platform/core/ui/states/app_load_widget.dart';
import 'package:lxp_platform/core/ui/states/flow_state_widget.dart';
import 'package:lxp_platform/core/utils/enums/flow_state.dart';
import 'package:lxp_platform/features/course_list/controllers/course_list_controller.dart';
import 'package:lxp_platform/features/course_list/ui/widgets/course_list_widget.dart';

class CourseListPage extends StatefulWidget {
  final CourseListController controller;

  const CourseListPage({super.key, required this.controller});

  @override
  State<CourseListPage> createState() => _CourseListPageState();
}

class _CourseListPageState extends State<CourseListPage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.controller.initPage();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: SafeArea(
        child: AnimatedBuilder(
          animation: widget.controller,
          builder: (context, child) {
            return _getWidget(widget.controller.state);
          },
        ),
      ),
    );
  }

  Widget _getWidget(int state) {
    switch (state) {
      case PageStates.successState:
        return CourseListWidget(controller: widget.controller);
      case PageStates.emptyState:
        return Center(
          child: SingleChildScrollView(
            child: FlowStateWidget(
              title: 'Nenhum curso disponível',
              description: 'Não encontramos cursos relacionados à alguma categoria.',
              hideButton: true,
              flowState: FlowState.empty,
            ),
          ),
        );
      case PageStates.loadingState:
        return const AppLoadWidget(label: 'Carregando cursos');
      case PageStates.noConnection:
        return Center(
          child: SingleChildScrollView(
            child: FlowStateWidget(
              function: () => widget.controller.loadAllCourses(refresh: true),
              title: "Sem conexão",
              description: "Verifique sua conexão com a internet.",
              flowState: FlowState.noConnection,
            ),
          ),
        );
      default:
        return Center(
          child: SingleChildScrollView(
            child: FlowStateWidget(
              function: () => widget.controller.loadAllCourses(refresh: true),
              title: "Erro ao carregar",
              description: "Ocorreu um erro desconhecido ao tentar carregar os cursos.",
              flowState: FlowState.error,
            ),
          ),
        );
    }
  }
}
