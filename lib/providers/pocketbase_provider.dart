import 'package:billkeep/config/app_config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketbase/pocketbase.dart';

final pbProvider = Provider((ref) => PocketBase(AppConfig.pocketbaseUrl));