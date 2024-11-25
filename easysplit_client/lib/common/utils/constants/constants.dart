import 'package:flutter/material.dart';

// BillImage Constants
class BillImageConstants {
  static const double baseWidth = 393;
  static const double baseHeight = 282;
  static const double itemLineHeight = 22;
  static const double itemTextWidth = 230;
  static const double itemAmountWidth = 130;
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
    "total": 0,
    "location": null,
  };

  static const TextStyle textStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: BillImageConstants.itemLineHeight / 16,
    fontFamily: 'Poppins',
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
const String clearContentMessage = "Clear current contents and back to home?";
const String deleteSplitMessage = "Delete this split?";
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
const String maximumSelectedFriendsToast =
    "You can select a maximum of 16 people";
const String maximumFriendsToast = "You can add a maximum of 20 people";
const String addFriendHint = "Add friend";
const String historyTitle = "History";
const String diningFriendsTitle = "Dining friends";
const String noHistoryText = "No history yet";
const String trySampleProcessTitle = "Try sample process";
const String aboutEasySplitTitle = "About EasySplit";
const String easySplitFAQTitle = "EasySplit FAQ";
const String feedbackTitle = "Feedback";
const String privacyPolicyTitle = "Privacy Policy";
const String termsOfServiceTitle = "Terms of Service";

// Help Texts
const String helpCardTitle = "Not sure how to Split?";
const String helpCardDesc1 = "No worries. ";
const String helpCardDesc2 = "Tap here";
const String helpCardDesc3 = " to try a sample process.😊";
const String selectSampleReceiptTitle = "Select a receipt you'd like to scan";

// Processing Texts
final List<String> processingTexts = [
  "Processing photo ",
  "Analysing items ",
  "Analysing price ",
  "Calculating amounts ",
  "Generalizing results ",
];

// Friends Color List
final firendColorList = [
  const Color(0xFFFDD91F),
  const Color(0xFFFB7472),
  const Color(0xFFFFA5AE),
  const Color(0xFF01BDA4),
  const Color(0xFFB38CFF),
  const Color(0xFFB3EA31),
  const Color(0xFFFCA952),
  const Color(0xFF8B99A6),
  const Color(0xFF53A6C4),
  const Color(0xFF5E69F6),
  const Color(0xFF3BCEF9),
  const Color(0xFF239DFF),
  const Color(0xFF86E0D6),
  const Color(0xFF7BC242),
  const Color(0xFF474E60),
  const Color(0xFFDBC4A1),
  const Color(0xFFCF7600),
  const Color(0xFFAF2026),
  const Color(0xFFFF5FC9),
  const Color(0xFFBAB9EA),
];
