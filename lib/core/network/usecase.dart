import 'package:lxp_platform/core/network/failure.dart';
import 'package:lxp_platform/core/network/result_data.dart';

abstract class Usecase<Output, Input> {
  Future<ResultData<Failure, Output>> call(Input params);
}

class NoParams {
  const NoParams();
}
