import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:plexus_noc/features/device_monitoring/domain/entities/alert_entity.dart';

part 'alert_state.dart';

class AlertCubit extends Cubit<AlertState> {
  AlertCubit() : super(AlertInitial());
}
