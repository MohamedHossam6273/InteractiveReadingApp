// lib/screens/download_helper.dart
// Conditional import: choose web implementation when building for web,
// otherwise choose the IO implementation.
import 'download_helper_io.dart'
    if (dart.library.html) 'download_helper_web.dart';

// the exported method `saveAndSharePdf` will be available from whichever implementation is used.
