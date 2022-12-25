import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liveasy/constants/color.dart';
import 'package:liveasy/constants/fontSize.dart';
import 'package:liveasy/constants/fontWeights.dart';
import 'package:liveasy/constants/spaces.dart';
import 'package:liveasy/controller/postLoadVariablesController.dart';
import 'package:liveasy/widgets/LoadConfirmationTemplate.dart';
import 'package:liveasy/widgets/buttons/backButtonWidget.dart';
import 'package:liveasy/widgets/buttons/loadConfirmationScreenButton.dart';
import 'package:liveasy/widgets/headingTextWidget.dart';
import 'package:liveasy/providerClass/providerData.dart';
import 'package:provider/provider.dart';

class LoadConfirmation extends StatefulWidget {
  const LoadConfirmation({Key? key}) : super(key: key);

  @override
  _LoadConfirmationState createState() => _LoadConfirmationState();
}

class _LoadConfirmationState extends State<LoadConfirmation> {
  @override
  Widget build(BuildContext context) {
    ProviderData providerData = Provider.of<ProviderData>(context);
    WidgetsBinding.instance
        .addPostFrameCallback((_) => providerData.updateUnitValue());
    // providerData.updateLoadWidget(true);
    PostLoadVariablesController postLoadVariables =
        Get.find<PostLoadVariablesController>();
    return Scaffold(
      backgroundColor: statusBarColor,
      body: SafeArea(
        child: Padding(
            padding: EdgeInsets.all(space_2),
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: space_4,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: space_2),
                              child: BackButtonWidget(),
                            ),
                            SizedBox(
                              width: space_3,
                            ),
                            HeadingTextWidget('loadConfirmation'.tr
                                // AppLocalizations.of(context)!.loadConfirmation
                                ),
                            // HelpButtonWidget(),
                          ],
                        ),
                        SizedBox(
                          height: space_4,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: space_3),
                          child: Text(
                            'reviewDetailsForYourLoad'.tr,
                            // AppLocalizations.of(context)!
                            //     .reviewDetailsForYourLoad,
                            style: TextStyle(
                                fontSize: size_9,
                                fontWeight: mediumBoldWeight,
                                color: liveasyBlackColor),
                          ),
                        ),
                        SizedBox(
                          height: space_4,
                        ),
                        Card(
                          elevation: 5,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(
                                space_3, space_2, space_3, space_3),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  child: LoadConfirmationTemplate(
                                      value:
                                          "${providerData.loadingPointPostLoad} ==>${providerData.unloadingPointCityPostLoad}",
                                      label: 'location'.tr
                                      // AppLocalizations.of(context)!
                                      //     .location
                                      ),
                                ),
                                LoadConfirmationTemplate(
                                    value: postLoadVariables.bookingDate.value,
                                    label: 'date'.tr
                                    // AppLocalizations.of(context)!.date
                                    ),
                                LoadConfirmationTemplate(
                                    value: providerData.truckTypeValue,
                                    label: 'truckType'.tr
                                    // AppLocalizations.of(context)!
                                    //     .truckType
                                    ),
                                LoadConfirmationTemplate(
                                    value:
                                        providerData.totalTyresValue.toString(),
                                    label: 'tyre'.tr
                                    // AppLocalizations.of(context)!.tyre
                                    ),
                                LoadConfirmationTemplate(
                                    value: providerData.passingWeightValue
                                        .toString(),
                                    label: 'weight'.tr
                                    // AppLocalizations.of(context)!.weight
                                    ),
                                LoadConfirmationTemplate(
                                    value: providerData.productType.tr,
                                    label: 'productType'.tr
                                    // AppLocalizations.of(context)!.productType
                                    ),
                                LoadConfirmationTemplate(
                                    value: providerData.price == 0
                                        ? 'priceNotGiven'.tr
                                        // AppLocalizations.of(context)!
                                        //         .priceNotGiven
                                        : "Rs.${providerData.price}/${providerData.unitValue}",
                                    label: 'price'.tr
                                    // AppLocalizations.of(context)!.price
                                    ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: space_6),
                    child: Padding(
                      padding: EdgeInsets.only(left: space_8, right: space_8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                              child:
                                  LoadConfirmationScreenButton(title: 'edit'.tr
                                      // AppLocalizations.of(context)!.edit
                                      )),
                          SizedBox(
                            width: space_10,
                          ),
                          Expanded(
                              child: LoadConfirmationScreenButton(
                                  title: 'confirm'.tr
                                  // AppLocalizations.of(context)!.confirm
                                  )),
                        ],
                      ),
                    ),
                  )

                  // HelpButtonWidget(),
                ],
              ),
            )),
      ),
    );
  }
}
