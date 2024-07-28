import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:track_my_things/gen/assets.gen.dart';
import 'package:track_my_things/l10n/l10n.dart';
import 'package:track_my_things/modal/product_modal.dart';
import 'package:track_my_things/service/shared_prefrence.dart';
import 'package:track_my_things/util/extension.dart';
import 'package:track_my_things/views/components/body_widget.dart';
import 'package:track_my_things/views/components/button.dart';
import 'package:track_my_things/views/components/input_field_form.dart';
import 'package:track_my_things/views/components/pick_image_bottom_sheet.dart';
import 'package:track_my_things/views/screens/add_product/bloc/product_bloc.dart';
import 'package:track_my_things/views/screens/fetch_image_data/bloc/fetch_image_data_bloc.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({
    super.key,
    this.productModal,
  });
  final ProductModal? productModal;

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  //form key
  final _formKey = GlobalKey<FormState>();

  //text editing controllers
  late final TextEditingController productNameController;
  late final TextEditingController purchasedDateController;
  late final TextEditingController warrantyPeriodController;
  late final TextEditingController warrantyEndDateController;
  late final TextEditingController noteController;

  //value notifier to add show image
  final billImageNotifier = ValueNotifier<File?>(null);
  final productImageNotifier = ValueNotifier<File?>(null);
  final warrantyEndDateNotifier = ValueNotifier<String?>('');
  //for test
  bool productImage = false;

  @override
  void initState() {
    productNameController = TextEditingController();
    purchasedDateController = TextEditingController(
      text: DateTime.now().toFormattedDate,
    );
    warrantyPeriodController =
        TextEditingController(text: AppPrefHelper.getDefaultWarrantyPeriod());
    warrantyEndDateController = TextEditingController();
    noteController = TextEditingController();

    calculateEndDate();
    super.initState();
  }

  @override
  void dispose() {
    productNameController.clear();
    purchasedDateController.clear();
    warrantyEndDateController.clear();
    warrantyPeriodController.clear();
    noteController.clear();
    billImageNotifier.dispose();
    productImageNotifier.dispose();

    super.dispose();
    log(productNameController.text);
  }

  @override
  Widget build(BuildContext context) {
    final appLocalization = AppLocalizations.of(context)!;
    return BlocConsumer<FetchImageDataBloc, FetchImageDataState>(
      listener: (context, ImageDataState) {},
      builder: (context, ImageDataState) {
    
        final isFetchingData =
            ImageDataState.runtimeType == FetchingImageDataLoadingState;

        if (ImageDataState is FetchingImageDataSuccessState) {
          
          if (ImageDataState.productModal!.productName!.isNotEmpty) {
            productNameController.text =
                ImageDataState.productModal!.productName!;
          }
          if (ImageDataState.productModal!.purchasedDate!.isNotEmpty &&
              RegExp(r'^\d{2} \w{3} \d{4}$')
                  .hasMatch(ImageDataState.productModal!.purchasedDate!)) {
            purchasedDateController.text =
                ImageDataState.productModal!.purchasedDate!;
            calculateEndDate();
          }
          if (ImageDataState.productModal!.warrantyPeriods!.isNotEmpty) {
            warrantyPeriodController.text =
                ImageDataState.productModal!.warrantyPeriods!;
            calculateEndDate();
          }
        }
        return BlocConsumer<ProductBloc, ProductState>(
          listener: (context, state) {
            if (state is ProductSuccessState) {
              Navigator.pop(context, true);
            }
            if (state is ProductFailureState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Product Added Failed : ${state.errorMsg}'),
                ),
              );
            }
          },
          builder: (context, state) {
            return Stack(
              children: [
                IgnorePointer(
                  ignoring: isFetchingData,
                  child: BodyWidget(
                    isLoading: state.runtimeType == ProductLoadingState,
                    child: Scaffold(
                      appBar: AppBar(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        leading: const BackButton(),
                        elevation: 2,
                        title: Text(
                          appLocalization.addProduct,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        centerTitle: true,
                      ),
                      body: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Form(
                          key: _formKey,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                ValueListenableBuilder(
                                  valueListenable: billImageNotifier,
                                  builder: (context, value, _) {
                                    return InkWell(
                                      onTap: () async {
                                        await PickImageBottomSheet()
                                            .showBottomSheet(context,
                                                (File? selectedImage) {
                                          billImageNotifier.value =
                                              selectedImage;
                                        });
                                        if (billImageNotifier.value != null) {
                                          context
                                              .read<FetchImageDataBloc>()
                                              .add(
                                                FetchDetailsFromBillImageEvent(
                                                  billImage:
                                                      billImageNotifier.value,
                                                ),
                                              );
                                        }
                                      },
                                      child: Container(
                                        height: 100,
                                        width: 100,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: const Color(0xFFC1CDF5),
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(14),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: billImageNotifier.value != null
                                              ? Image.file(
                                                  File(
                                                    billImageNotifier
                                                        .value!.path,
                                                  ),
                                                  fit: BoxFit.cover,
                                                )
                                              : Assets.images.addImage
                                                  .image(fit: BoxFit.cover),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                Text(
                                  appLocalization
                                      .addProductBillAndWeWillAutoFill,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                InputFieldForm(
                                  fieldName: appLocalization.productName,
                                  controller: productNameController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return appLocalization
                                          .productNameRequired;
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                InkWell(
                                  onTap: () {},
                                  child: InputFieldForm(
                                    fieldName: appLocalization.purchasedDate,
                                    controller: purchasedDateController,
                                    icon: Icons.calendar_month,
                                    function: () async {
                                      await _showDatePicker(
                                        context,
                                        purchasedDateController,
                                        appLocalization.selectPurchasedDate,
                                        DateTime(2000),
                                      );
                                      calculateEndDate();
                                    },
                                    readOnly: true,
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                InputFieldForm(
                                  fieldName: appLocalization.warrantyPeriod,
                                  controller: warrantyPeriodController,
                                  keyboardType: TextInputType.number,
                                  onSubmit: (value) {
                                    calculateEndDate();
                                  },
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Warranty Periods is required';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                InputFieldForm(
                                  readOnly: true,
                                  fieldName: appLocalization.warrantyEndDate,
                                  controller: warrantyEndDateController,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                ValueListenableBuilder(
                                  valueListenable: productImageNotifier,
                                  builder: (context, value, _) {
                                    return Container(
                                      height: 55,
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: const Color(0xFFC1CDF5),
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: productImageNotifier.value !=
                                                null
                                            ? Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    appLocalization.imageAdded,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onSecondaryFixedVariant,
                                                    ),
                                                  ),
                                                  if (productImageNotifier
                                                          .value !=
                                                      null)
                                                    Image.file(
                                                      File(
                                                        productImageNotifier
                                                            .value!.path,
                                                      ),
                                                    )
                                                  else
                                                    Text(
                                                      appLocalization.noImage,
                                                    ),
                                                  InkWell(
                                                    onTap: () async {
                                                      productImageNotifier
                                                          .value = null;
                                                    },
                                                    child: Icon(
                                                      Icons.delete,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .error,
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : InkWell(
                                                onTap: () async {
                                                  await PickImageBottomSheet()
                                                      .showBottomSheet(context,
                                                          (
                                                    File? selectedImage,
                                                  ) {
                                                    productImageNotifier.value =
                                                        selectedImage;
                                                  });
                                                },
                                                child: Text(
                                                  appLocalization.productImage,
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onSecondaryFixedVariant,
                                                  ),
                                                ),
                                              ),
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                InputFieldForm(
                                  fieldName: appLocalization.note,
                                  controller: noteController,
                                  maxLines: 3,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                InkWell(
                                  onTap: () async {
                                    if (_formKey.currentState!.validate()) {
                                      context.read<ProductBloc>().add(
                                            AddProductEvent(
                                              productModal: ProductModal(
                                                productName:
                                                    productNameController.text,
                                                purchasedDate:
                                                    purchasedDateController.text
                                                        .toDate()!
                                                        .toIso8601String(),
                                                warrantyPeriods:
                                                    warrantyPeriodController
                                                        .text,
                                                warrantyEndsDate:
                                                    warrantyEndDateController
                                                        .text
                                                        .toDate()!
                                                        .toIso8601String(),
                                                notes: noteController.text,
                                                userId: AppPrefHelper.getUID(),
                                              ),
                                              billImage:
                                                  billImageNotifier.value,
                                              productImage:
                                                  productImageNotifier.value,
                                            ),
                                          );
                                   
                                    }
                                  },
                                  child: SubmitButton(
                                    heading: appLocalization.addProduct,
                                  ),
                                ),
                                Text(
                                  context.lang.verifyDetails,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondaryFixedVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                if (isFetchingData)
                  Material(
                    color: Theme.of(context).brightness == Brightness.light
                        ? Theme.of(context)
                            .colorScheme
                            .tertiary
                            .withOpacity(0.5)
                        : Theme.of(context)
                            .colorScheme
                            .tertiary
                            .withOpacity(.15),
                    child: Center(
                      child: Container(
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(14),
                          ),
                          border: Border(
                            bottom: BorderSide(
                              width: 4,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            top: BorderSide(
                              width: 4,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            right: BorderSide(
                              width: 4,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            left: BorderSide(
                              width: 4,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const CircularProgressIndicator(),
                            Text(
                              'Fetching Details',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        );
      },
    );
  }

  Widget successHomePage() {
    return const Text('data');
  }

  Future<void> _showDatePicker(
    BuildContext context,
    TextEditingController controller,
    String helpText,
    final DateTime firstDate,
  ) async {
    final pickedDate = await showDatePicker(
      helpText: helpText,
      context: context,
      initialDate: DateTime.now(),
      firstDate: firstDate,
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: ThemeData(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).colorScheme.primary, // Primary color
              onPrimary: Theme.of(context).colorScheme.onSurface, // Text color
              onSurface:
                  Theme.of(context).colorScheme.secondary, // Background color
            ),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null) {
      controller.text = pickedDate.toFormattedDate;
    }
  }

  void calculateEndDate() {
    final startDate =
        DateFormat('dd MMM yyyy').parse(purchasedDateController.text);
    final numberOfMonths = int.tryParse(warrantyPeriodController.text) ?? 0;
    warrantyEndDateNotifier.value =
        startDate.add(Duration(days: numberOfMonths * 30)).toFormattedDate;
    warrantyEndDateController.text = warrantyEndDateNotifier.value!;
  }
}
