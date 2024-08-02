import 'package:easysplit_flutter/common/widgets/alerts/rounded_corner_bottom_sheet.dart';
import 'package:easysplit_flutter/common/widgets/buttons/app_button.dart';
import 'package:flutter/material.dart';

Future<T?> showDoubleCheckBottomSheet<T>(
  BuildContext context, {
  required String title,
  String? message,
  String? confirmText,
  String? cancelText,
  Color? confirmButtonColor,
  Color? cancelButtonColor,
  bool showConfirmOnly = false,
  bool flip = false,
  void Function()? onConfirm,
  void Function()? onCancel,
}) {
  return showRoundedCornerBottomSheet(
    context,
    child: DoubleCheckBottomSheet(
      title: title,
      message: message,
      confirmText: confirmText,
      cancelText: cancelText,
      confirmButtonColor: confirmButtonColor,
      cancelButtonColor: cancelButtonColor,
      showConfirmOnly: showConfirmOnly,
      flip: flip,
      onConfirm: onConfirm,
      onCancel: onCancel,
    ),
  );
}

class DoubleCheckBottomSheet extends StatelessWidget {
  final String? title;
  final String? message;
  final String? confirmText;
  final String? cancelText;
  final Color? confirmButtonColor;
  final Color? cancelButtonColor;
  final bool showConfirmOnly;
  final bool flip;
  final void Function()? onConfirm;
  final void Function()? onCancel;
  const DoubleCheckBottomSheet({
    super.key,
    this.title,
    this.message,
    this.confirmText,
    this.cancelText,
    this.confirmButtonColor,
    this.cancelButtonColor,
    this.showConfirmOnly = false,
    this.flip = false,
    this.onConfirm,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            alignment: Alignment.center,
            constraints: const BoxConstraints(
              minHeight: 120,
            ),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title ?? '',
                    maxLines: null,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    )),
                if (message != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 24),
                    child: Text(
                      message ?? '',
                      maxLines: null,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(
            height: 61,
            child: showConfirmOnly
                ? AppButton.inkwell(
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        confirmText ?? 'Confirm',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: confirmButtonColor ?? Colors.black,
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      onConfirm?.call();
                    },
                  )
                : flip
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: AppButton.inkwell(
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  confirmText ?? 'Confirm',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: confirmButtonColor ?? Colors.black,
                                  ),
                                ),
                              ),
                              onTap: () {
                                Navigator.of(context).pop();
                                onConfirm?.call();
                              },
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 22,
                            color: Theme.of(context).primaryColor,
                          ),
                          Expanded(
                            child: AppButton.inkwell(
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  cancelText ?? 'Cancel',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: cancelButtonColor ?? Colors.black,
                                  ),
                                ),
                              ),
                              onTap: () {
                                Navigator.of(context).pop();
                                onCancel?.call();
                              },
                            ),
                          ),
                        ],
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: AppButton.inkwell(
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  cancelText ?? 'Cancel',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: cancelButtonColor ?? Colors.black,
                                  ),
                                ),
                              ),
                              onTap: () {
                                Navigator.of(context).pop();
                                onCancel?.call();
                              },
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 22,
                            color: Theme.of(context).primaryColor,
                          ),
                          Expanded(
                            child: AppButton.inkwell(
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  confirmText ?? 'Confirm',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: confirmButtonColor ?? Colors.black,
                                  ),
                                ),
                              ),
                              onTap: () {
                                Navigator.of(context).pop();
                                onConfirm?.call();
                              },
                            ),
                          ),
                        ],
                      ),
          ),
        ],
      ),
    );
  }
}
