import 'package:flutter_test/flutter_test.dart';
import 'package:recipe_app_flutter/utils/stringValidator.dart';

void main() {
  group("InputValidation", () {
    test("Test for valid email from the input field", () {
      var result = "abc@gmail.com".isValidEmail();
      expect(result, true);

      var result2 = "abbb@.com".isValidEmail();
      expect(result2, false);
    });

    test("Test for valid Username for Login or Register", () {
      var result = "thisisnew_a".isValidName();
      expect(result, true);

      var result2 = "thisisn.ew@".isValidName();
      expect(result2, false);
    });

    test("Test for valid Password for Login or Register", () {
      var result = "1231".isValidName();
      expect(result, true);

      var result2 = "thisis_-n.ew@".isValidName();
      expect(result2, false);
    });
  });
}
