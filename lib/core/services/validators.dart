String emailValidator(String content) {
  if (content.contains('@')) {
    if (content.length == 0) {
      return 'Please enter your Email ID';
    } else {
      return null;
    }
  } else {
    return 'Please enter a VALID Email ID';
  }
}

String passwordValidator(String content) {
  if (content.length < 8) {
    return 'Minimum 8 DIGIT password';
  } else {
    return null;
  }
}
