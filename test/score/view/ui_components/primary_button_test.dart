import 'package:flutter_test/flutter_test.dart';
import 'package:smack_talking_scoreboard_v3/score/view/ui_components/primary_button.dart';

void main() {
  test('Should throw assertion if button is created without label or child',
      () async {
    expect(PrimaryButton.filled, throwsAssertionError);
    expect(PrimaryButton.outlined, throwsAssertionError);
  });
}
