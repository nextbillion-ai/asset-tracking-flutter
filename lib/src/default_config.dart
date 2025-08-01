import 'nb_encode.dart';

class DefaultConfig with NBEncode {
  DefaultConfig({
    required this.enhanceService,
    required this.repeatInterval,
    required this.workerEnabled,
    required this.crashRestartEnabled,
    required this.workOnMainThread,
  });

  factory DefaultConfig.fromJson(Map<String,dynamic> json) => DefaultConfig(
      enhanceService: json['enhanceService'] as bool,
      repeatInterval: json['repeatInterval'] as int,
      workerEnabled: json['workerEnabled'] as bool,
      crashRestartEnabled: json['crashRestartEnabled'] as bool,
      workOnMainThread: json['workOnMainThread'] as bool,
    );


  bool enhanceService;
  int repeatInterval;
  bool workerEnabled;
  bool crashRestartEnabled;
  bool workOnMainThread;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'enhanceService': enhanceService,
        'repeatInterval': repeatInterval,
        'workerEnabled': workerEnabled,
        'crashRestartEnabled': crashRestartEnabled,
        'workOnMainThread': workOnMainThread,
      };
}
