// RegExp mobileRegx = RegExp(r'^(\+91[\-\s]?)?[0]?(91)?[6789]\d{9}$');
RegExp haveExtaZeroRegx = RegExp(r'[1-9]*(\.){1}[0]*$');
RegExp get unicodeRegx => RegExp(r'((\\u)|(\u))?(?<code>[\d\w]{4})');

RegExp expIntAllow = RegExp('[0-9]');

final vechicalNumberRegx = RegExp(
  r'([A-Z]{2}[0-9]{2}[A-Z]{1,2}[0-9]{4})|([0-9]{2}BH[0-9]{4}[A-HJ-NP-Z]{1,2})',
  caseSensitive: false,
);
final normalNumberRegx = RegExp(
  r'([A-Z]{2}[0-9]{2}[A-Z]{1,2}[0-9]{4})',
  unicode: true,
);
final bhSeriesNumberRegx = RegExp(
  r'([0-9]{2}BH[0-9]{4}[A-HJ-NP-Z]{1,2})',
  unicode: true,
);

final RegExp upiRegex = RegExp(r'^[\w.-]+@[\w.-]+$', caseSensitive: false);

final RegExp gstNumberRegx = RegExp(
  r"^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$",
);

final RegExp mobileNumberStrictRegx = RegExp(r"^\+?\d{7,16}$");

/// including integers, decimals, negative numbers, etc
final RegExp numberRegx = RegExp(r'-?\d+(\.\d+)?');

final RegExp numaricCharRegx = RegExp(r'[0-9]');
final RegExp alphabetCharRegx = RegExp(r'[a-zA-z]');
final RegExp colonCharRegx = RegExp(r'[0-9]');
final RegExp nfrfCardIDRegx = RegExp(
  r'^(([a-zA-Z0-9]){2,3}\:){3,15}([a-zA-Z0-9]){2,3}\:?$',
);
final RegExp httpOrFileRegx = RegExp(r'(http(s)?:\/\/)|(file:\/\/)');
