import 'package:hive/hive.dart';

part 'insults_model.g.dart';

@HiveType(typeId: 0)
class InsultsModel extends HiveObject {
  @HiveField(1)
  List<String> playerInsults = [];

  @HiveField(2)
  List<String> tieInsults = [];
}
