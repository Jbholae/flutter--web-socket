import 'package:flutter/material.dart';

import 'colors.dart';

class AppTheme {
  static TextStyle headline1 = const TextStyle(
    color: AppColors.black,
    height: 48.0 / 36.0,
    // line height calculated as is fontSize * height so, <expected-height>/<font-size>
    fontSize: 36.0,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.bold,
    leadingDistribution: TextLeadingDistribution.even,
  );

  static TextStyle headline2Bold = const TextStyle(
    color: AppColors.black,
    height: 36.0 / 18.0,
    fontSize: 18.0,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.bold,
    leadingDistribution: TextLeadingDistribution.even,
  );

  static TextStyle heading2Regular = const TextStyle(
    color: AppColors.black,
    height: 36.0 / 18.0,
    fontSize: 18.0,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w600,
    leadingDistribution: TextLeadingDistribution.even,
  );

  static TextStyle button = const TextStyle(
    color: AppColors.black,
    height: 26.0 / 18.0,
    fontSize: 18.0,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w600,
    leadingDistribution: TextLeadingDistribution.even,
  );

  static TextStyle captionBold = const TextStyle(
    color: AppColors.black,
    height: 22.0 / 16.0,
    fontSize: 16.0,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.bold,
    leadingDistribution: TextLeadingDistribution.even,
  );

  static TextStyle captionRegular = const TextStyle(
    color: AppColors.black,
    height: 22.0 / 16.0,
    fontSize: 16.0,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.normal,
    leadingDistribution: TextLeadingDistribution.even,
  );

  static TextStyle textBold = const TextStyle(
    color: AppColors.black,
    height: 20.0 / 14.0,
    fontSize: 14.0,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.bold,
    leadingDistribution: TextLeadingDistribution.even,
  );

  static TextStyle textRegular = const TextStyle(
    color: AppColors.black,
    height: 20.0 / 14.0,
    fontSize: 14.0,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.normal,
    leadingDistribution: TextLeadingDistribution.even,
  );

  static TextStyle subHeading = const TextStyle(
    color: AppColors.black,
    height: 20.0 / 12.0,
    fontSize: 12.0,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.normal,
    leadingDistribution: TextLeadingDistribution.even,
  );

  static ThemeData get light {
    return ThemeData(
      brightness: Brightness.light,
      primarySwatch: AppColors.primary,
      scaffoldBackgroundColor: Colors.white,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      // fontFamily: GoogleFonts.sourceSansPro().fontFamily,
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        labelStyle: captionRegular,
        floatingLabelStyle: captionRegular,
        hintStyle: captionRegular.copyWith(color: AppColors.greyDark),
        counterStyle: subHeading.copyWith(
          color: AppColors.greyDark,
        ),
        errorStyle: subHeading.copyWith(color: Colors.red),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        focusedErrorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(24)),
          borderSide: BorderSide.none,
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(24)),
          borderSide: BorderSide.none,
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(24)),
          borderSide: BorderSide.none,
        ),
        disabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(24)),
          borderSide: BorderSide.none,
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(24)),
          borderSide: BorderSide.none,
        ),
      ),
      textTheme: TextTheme(
        headline1: headline1,
        headline2: headline2Bold,
        headline3: heading2Regular,
        subtitle1: captionBold,
        subtitle2: captionRegular,
        bodyText1: textBold,
        bodyText2: textRegular,
        caption: subHeading,
        button: button,
      ),
      appBarTheme: const AppBarTheme(
        actionsIconTheme: IconThemeData(color: AppColors.black),
        shadowColor: Colors.transparent,
        iconTheme: IconThemeData(color: AppColors.black),
        titleTextStyle: TextStyle(color: AppColors.black),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: captionBold,
        unselectedLabelStyle: captionRegular,
      ),
    );
  }
}
