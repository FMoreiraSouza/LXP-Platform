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

class _CourseListPageState extends State<CourseListPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.controller.initPage();
    });
    super.initState();
  }

  @override
  void dispose() {
    widget.controller.disposeControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cursos Disponíveis'), centerTitle: true, elevation: 1),
      body: Stack(
        children: [
          // Conteúdo principal baseado no estado
          AnimatedBuilder(
            animation: widget.controller,
            builder: (context, child) {
              return _getWidget(widget.controller.state);
            },
          ),

          // Loading overlay
          AnimatedBuilder(
            animation: widget.controller,
            builder: (context, child) {
              return Visibility(visible: widget.controller.isLoading, child: const AppLoadWidget());
            },
          ),
        ],
      ),
    );
  }

  Widget _getWidget(int state) {
    switch (state) {
      case PageStates.successState:
        return CourseListWidget(controller: widget.controller);

      case PageStates.emptyState:
        return FlowStateWidget(
          title: 'Nenhum curso disponível',
          description: 'Não encontramos cursos nesta categoria no momento.',
          hideButton: true,
          flowState: FlowState.empty,
        );

      case PageStates.loadingState:
        return const AppLoadWidget(
          label: 'Carregando cursos...',
          bgColor: Colors.transparent,
          textColor: Colors.black54,
        );

      case PageStates.noConnection:
        return FlowStateWidget(
          function: () => widget.controller.loadAllCourses(),
          title: "Sem conexão",
          description: "Verifique sua conexão com a internet e tente novamente.",
          flowState: FlowState.noConnection,
        );

      case PageStates.errorState:
      default:
        return FlowStateWidget(
          function: () => widget.controller.loadAllCourses(),
          title: "Erro ao carregar",
          description: widget.controller.error ?? "Ocorreu um erro inesperado.",
          flowState: FlowState.error,
        );
    }
  }
}
