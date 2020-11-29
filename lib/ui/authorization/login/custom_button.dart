import 'package:boilerplate/constants/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Color color;
  final Color textColor;
  final String text;
  final Widget image;
  final Icon icon;
  final VoidCallback onPressed;

  const CustomButton({
    this.icon,
    this.color,
    this.textColor,
    this.text,
    this.onPressed,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minWidth: double.infinity,
      ),
      child: image != null
          ? OutlineButton(
              color: color,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: kPaddingL),
                    child: image,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: kPaddingL),
                    child: icon,
                  ),
                  Text(
                    text,
                    style: Theme.of(context).textTheme.subtitle1.copyWith(
                        color: textColor, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              onPressed: onPressed,
            )
          : FlatButton(
              color: color,
              padding: const EdgeInsets.all(kPaddingM),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: Text(
                text,
                style: Theme.of(context)
                    .textTheme
                    .subtitle1
                    .copyWith(color: textColor, fontWeight: FontWeight.bold),
              ),
              onPressed: onPressed,
            ),
    );
  }
}
