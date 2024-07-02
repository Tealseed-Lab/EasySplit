import 'package:flutter/material.dart';

// BillImage Constants
class BillImageConstants {
  static const double baseWidth = 393;
  static const double baseHeight = 260;
  static const double itemLineHeight = 22;
  static const double itemTextWidth = 260;
  static const String shareByAllText = 'Shared by all';
  static const Color unassignedItemColor = Color.fromRGBO(255, 72, 70, 1);
  static const Color additionalChargesColor = Color.fromRGBO(60, 60, 67, 0.60);

  static const Map<String, dynamic> emptyReceiptData = {
    "additional_charges": [
      {"amount": 0, "key": 1, "name": "Service Charge"},
      {"amount": 0, "key": 2, "name": "GST"}
    ],
    "additional_discounts": [
      {"amount": 0, "key": 1, "name": "Discount"}
    ],
    "items": [],
    "total": 0
  };

  static const TextStyle textStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );
}

// Messages
const String payByText = "Pay by";
const String byAllText = "By all";
const String addItemPlaceholder = "Add item";
const String itemNamePlaceholder = "Item Name";
const String takePhotoMessage = "Take Photo of the Receipt";
const String noCameraAccessAlert = "No access to camera";
const String goToSettingsMessage = "Settings";
const String cameraPermissionTitle = "Unable to access camera";
const String cameraPermissionMessage =
    "Allow access to the camera for a more comprehensive experience.";
const String photoLibraryPermissionTitle = "Unable to access photo library";
const String photoLibraryPermissionMessage =
    "Allow access to the photo library for a more comprehensive experience.";
const String clearConstantMessage =
    "Clear current contents and back to camera?";
const String dragPersonPlaceholderText = "Drag the person to here";
const String manualEnterBillPrompt = "Enter the bill manually";
const String connectionFailedText = "Connection failed";
const String networkErrorPrompt = "Please check your network and ";
const String networkErrorTextRetry = "Retry";
const String orText = "or";
const String noTextErrorText = "No text detected";
const String noTextErrorPrompt = "Please retake the photo and try again";
const String shareLogsTitle = "Share Logs";
const String shareLogsMessage = "Do you want to share the logs?";
const String shareLogsSubject = "Logs";
const String shareLogsText = "Here are the logs.";

// Processing Texts
final List<String> processingTexts = [
  "Processing photo ",
  "Analysing items ",
  "Analysing price ",
  "Calculating amounts ",
  "Generalizing results ",
];
