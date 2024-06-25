import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:warranty_tracker/gen/assets.gen.dart';
import 'package:warranty_tracker/l10n/l10n.dart';
import 'package:warranty_tracker/modal/product_modal.dart';
import 'package:warranty_tracker/routes/routes_names.dart';
import 'package:warranty_tracker/service/shared_prefrence.dart';
import 'package:warranty_tracker/util/extension.dart';
import 'package:warranty_tracker/views/components/body_widget.dart';
import 'package:warranty_tracker/views/components/button.dart';
import 'package:warranty_tracker/views/components/input_field_form.dart';
import 'package:warranty_tracker/views/screens/add_product/bloc/product_bloc.dart';

class UpdateProduct extends StatefulWidget {
  const UpdateProduct({super.key, this.productModal});
  final ProductModal? productModal;
  @override
  State<UpdateProduct> createState() => _UpdateProductState();
}

class _UpdateProductState extends State<UpdateProduct> {
  final _formKey = GlobalKey<FormState>();

  final productStateNotifier = ValueNotifier<String>('updated');

  late final TextEditingController productNameController;
  late final TextEditingController purchasedDateController;
  late final TextEditingController warrantyPeriodController;
  late final TextEditingController warrantyEndDateController;
  late final TextEditingController noteController;

  @override
  void initState() {
    productNameController =
        TextEditingController(text: widget.productModal?.productName);
    purchasedDateController = TextEditingController(
      text: widget.productModal!.purchasedDate!.toDateTime()!.toFormattedDate,
    );
    warrantyPeriodController = TextEditingController(
      text: widget.productModal?.warrantyPeriods.toString(),
    );
    warrantyEndDateController = TextEditingController(
      text:
          widget.productModal?.warrantyEndsDate!.toDateTime()!.toFormattedDate,
    );
    noteController = TextEditingController(text: widget.productModal?.notes);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductBloc, ProductState>(
      listener: (context, state) {
        if (state is ProductSuccessState) {
          if (productStateNotifier.value == 'deleted') {
            Navigator.pop(context, 'deleted');
          } else {
            Navigator.pop(context, 'updated');
          }
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
        return BodyWidget(
          isLoading: state.runtimeType == ProductLoadingState,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              leading: const BackButton(),
              elevation: 2,
              title: Text(
                context.lang.updateProduct,
                //'Update Product',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: IconButton(
                    onPressed: () {
                      showDialog<void>(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text(
                              context.lang.deleteProduct,
                              //'Delete Product',
                            ),
                            content: Text(
                              '''${context.lang.areYouSure} ${widget.productModal!.productName}''',
                              //'Are you sure you want to delete ${widget.productModal!.productName} ',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  context.lang.cancel,
                                  //'Cancel',
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondaryFixedVariant,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () async {
                                  context.read<ProductBloc>().add(
                                        DeleteProductEvent(
                                          productModal: widget.productModal!,
                                        ),
                                      );
                                  productStateNotifier.value = 'deleted';
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  context.lang.delete,
                                  //'Delete',
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    icon: const Icon(Icons.delete),
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ],
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
                      Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFFC1CDF5)),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: widget.productModal?.billImage != null
                              ? InkWell(
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      RoutesName.fullImage,
                                      arguments: widget.productModal?.billImage,
                                    );
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(14),
                                    child: Image.network(
                                      widget.productModal!.billImage!,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                )
                              : Assets.images.noImage.image(fit: BoxFit.cover),
                        ),
                      ),
                      if (widget.productModal!.billImage != null)
                        const Text('')
                      else
                        const Text(
                          'Product Bill is not available',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      const SizedBox(
                        height: 20,
                      ),
                      InputFieldForm(
                        fieldName: context.lang.productName,
                        //fieldName: 'Product Name',
                        controller: productNameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            // return context.lang.productNameRequired;
                            return 'Product Name is Required';
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
                          fieldName: context.lang.purchasedDate,
                          // fieldName: 'Purchased Date',
                          controller: purchasedDateController,
                          icon: Icons.calendar_month,
                          function: () {
                            _showDatePicker(
                              context,
                              purchasedDateController,
                              context.lang.selectPurchasedDate,
                              //'Select Purchased Date',
                              DateTime(2000),
                            );
                          },
                          readOnly: true,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      InputFieldForm(
                        fieldName: context.lang.warrantyPeriod,
                        //fieldName: 'Warranty Periods',
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
                        fieldName: context.lang.warrantyEndDate,
                        //fieldName: 'Warranty End Date',
                        controller: warrantyEndDateController,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: 55,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFFC1CDF5)),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: widget.productModal!.productImage != null
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      context.lang.imageAvailable,
                                      // 'Image Available',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSecondaryFixedVariant,
                                      ),
                                    ),
                                    if (widget.productModal!.productImage !=
                                        null)
                                      InkWell(
                                        onTap: () {
                                          Navigator.pushNamed(
                                            context,
                                            RoutesName.fullImage,
                                            arguments: widget
                                                .productModal?.productImage,
                                          );
                                        },
                                        child: Image.network(
                                          widget.productModal!.productImage!,
                                        ),
                                      )
                                    else
                                      Text(
                                        context.lang.noImage,
                                        //'No Image',
                                      ),
                                    const SizedBox(),
                                  ],
                                )
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      context.lang.noImage,
                                      //'Image Added',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSecondaryFixedVariant,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      InputFieldForm(
                        // fieldName: context.lang.note,
                        fieldName: 'Note',
                        controller: noteController,
                        maxLines: 3,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        onTap: () async {
                          if (_formKey.currentState!.validate()) {
                            context.read<ProductBloc>().add(
                                  UpdateProductEvent(
                                    productModal: ProductModal(
                                      billImage: widget.productModal!.billImage,
                                      productImage:
                                          widget.productModal!.productImage,
                                      productId: widget.productModal!.productId,
                                      productName: productNameController.text,
                                      purchasedDate: purchasedDateController
                                          .text
                                          .toDate()!
                                          .toIso8601String(),
                                      warrantyPeriods:
                                          warrantyPeriodController.text,
                                      warrantyEndsDate:
                                          warrantyEndDateController.text
                                              .toDate()!
                                              .toIso8601String(),
                                      notes: noteController.text,
                                      userId: AppPrefHelper.getUID(),
                                    ),
                                  ),
                                );
                            productStateNotifier.value = 'updated';
                          }
                        },
                        child: SubmitButton(
                          heading: context.lang.updateProduct,
                          //  heading: 'Update Product',
                        ),
                      ),
                      Text(
                        context.lang.imagesCanNotBeUpdated,
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
        );
      },
    );
  }

  Future<void> _showDatePicker(
    BuildContext context,
    TextEditingController controller,
    String helpText,
    DateTime firstDate,
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
    setState(() {
      warrantyEndDateController.text =
          startDate.add(Duration(days: numberOfMonths * 30)).toFormattedDate;
    });
  }
}
