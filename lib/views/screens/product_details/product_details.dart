import 'package:flutter/material.dart';
import 'package:track_my_things/gen/assets.gen.dart';
import 'package:track_my_things/l10n/l10n.dart';
import 'package:track_my_things/modal/product_modal.dart';
import 'package:track_my_things/routes/routes_names.dart';
import 'package:track_my_things/util/extension.dart';
import 'package:track_my_things/views/components/button.dart';
import 'package:track_my_things/views/components/input_field_form.dart';

class ProductDetails extends StatefulWidget {
  const ProductDetails({required this.productModal, super.key});
  final ProductModal productModal;
  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  late final TextEditingController productNameController;
  late final TextEditingController purchasedDateController;
  late final TextEditingController warrantyPeriodController;
  late final TextEditingController warrantyEndDateController;
  late final TextEditingController noteController;

  @override
  void initState() {
    // TODO: implement initState
    productNameController =
        TextEditingController(text: widget.productModal.productName);
    purchasedDateController = TextEditingController(
      text: widget.productModal.purchasedDate!.toDateTime()!.toFormattedDate,
    );
    warrantyPeriodController = TextEditingController(
      text: widget.productModal.warrantyPeriods.toString(),
    );
    warrantyEndDateController = TextEditingController(
      text: widget.productModal.warrantyEndsDate!.toDateTime()!.toFormattedDate,
    );
    noteController = TextEditingController(text: widget.productModal.notes);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        leading: const BackButton(),
        elevation: 2,
        title: const Text(
          'Product Details',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
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
                  child: widget.productModal.billImage != null
                      ? InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              RoutesName.fullImage,
                              arguments: widget.productModal.billImage,
                            );
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: Image.network(
                              widget.productModal.billImage!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      : Assets.images.noImage.image(fit: BoxFit.cover),
                ),
              ),
              if (widget.productModal.billImage != null)
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
                controller: productNameController,
                readOnly: true,
              ),
              const SizedBox(
                height: 20,
              ),
              InputFieldForm(
                fieldName: context.lang.purchasedDate,
                controller: purchasedDateController,
                readOnly: true,
              ),
              const SizedBox(
                height: 20,
              ),
              InputFieldForm(
                fieldName: context.lang.warrantyPeriod,
                //fieldName: 'Warranty Periods',
                controller: warrantyPeriodController,
                keyboardType: TextInputType.number,
                readOnly: true,
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
                  child: widget.productModal.productImage != null
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            if (widget.productModal.productImage != null)
                              InkWell(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    RoutesName.fullImage,
                                    arguments: widget.productModal.productImage,
                                  );
                                },
                                child: Image.network(
                                  widget.productModal.productImage!,
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                readOnly: true,
              ),
              const SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    RoutesName.updateProduct,
                    arguments: widget.productModal,
                  );
                },
                child: const SubmitButton(
                  heading: 'Edit Details',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
