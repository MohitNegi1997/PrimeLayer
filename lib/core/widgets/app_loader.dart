import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primelayer_admin_panel/core/widgets/loader_cubit.dart';
import 'package:primelayer_admin_panel/core/widgets/printer_loader_painter.dart';

class AppLoader extends StatelessWidget {
  const AppLoader({super.key, this.size = 160});

  final double size;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoaderCubit(),
      child: SizedBox(
        width: size,
        height: size,
        child: BlocBuilder<LoaderCubit, double>(
          builder: (context, progress) {
            return CustomPaint(
              painter: PrinterLoaderPainter(progress: progress),
            );
          },
        ),
      ),
    );
  }
}
