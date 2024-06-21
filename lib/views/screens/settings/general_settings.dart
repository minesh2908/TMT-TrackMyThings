import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:warranty_tracker/modal/user_model.dart';
import 'package:warranty_tracker/service/shared_prefrence.dart';
import 'package:warranty_tracker/views/components/button.dart';
import 'package:warranty_tracker/views/components/input_field_form.dart';
import 'package:warranty_tracker/views/screens/add_product/bloc/product_bloc.dart';
import 'package:warranty_tracker/views/screens/auth/bloc/auth_bloc.dart';

class GeneralSettings extends StatefulWidget {
  const GeneralSettings({super.key});

  @override
  State<GeneralSettings> createState() => _GeneralSettingsState();
}

class _GeneralSettingsState extends State<GeneralSettings> {
  @override
  void initState() {
    print('===== ${AppPrefHelper.getDefaultWarrantyPeriod()}');
    super.initState();
  }

  final defaultWarrantyController =
      TextEditingController(text: AppPrefHelper.getDefaultWarrantyPeriod());
  String? _selectedValue;
  final _formKey = GlobalKey<FormState>();
  final sortByNotifier =
      ValueNotifier<String>(AppPrefHelper.getSortProductBy());
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        print(state.runtimeType);
        if (state is AccountUpdatedState) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Settings Updated Succesfully',
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            elevation: 2,
            title: Text(
              AppLocalizations.of(context)!.generalSetting,
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sort item by',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  const SizedBox(height: 5),
                  ValueListenableBuilder(
                    valueListenable: sortByNotifier,
                    builder: (context, value, _) {
                      return Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFFC1CDF5)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            dropdownColor:
                                Theme.of(context).colorScheme.onPrimary,
                            borderRadius: BorderRadius.circular(14),
                            value: sortByNotifier.value,
                            onChanged: (value) {
                              sortByNotifier.value = value!;
                            },
                            items: [
                              'Warranty end date',
                              'Purchased date',
                              'Product name',
                            ].map((e) {
                              return DropdownMenuItem<String>(
                                value: e,
                                child: Text(
                                  e,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  InputFieldForm(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Default Warranty Period can not be empty';
                      }
                      return null;
                    },
                    fieldName: 'Default Warranty months(in months)',
                    controller: defaultWarrantyController,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  if (state.runtimeType == AuthLoadingState)
                    const Center(child: CircularProgressIndicator())
                  else
                    InkWell(
                      onTap: () async {
                        if (_formKey.currentState!.validate()) {
                          await AppPrefHelper.setSortProductBy(
                            sortProductBy: sortByNotifier.value,
                          );
                          context.read<ProductBloc>().add(GetAllProductEvent());
                          context.read<AuthBloc>().add(
                                UpdateUserAccountDetails(
                                  userModel: UserModel(
                                    email: AppPrefHelper.getEmail(),
                                    name: AppPrefHelper.getDisplayName(),
                                    phoneNumber: AppPrefHelper.getPhoneNumber(),
                                    userId: AppPrefHelper.getUID(),
                                    defaultWarrantyPeriod:
                                        defaultWarrantyController.text,
                                    sortItemBy: _selectedValue,
                                  ),
                                ),
                              );
                          await AppPrefHelper.setDefaultWarrantyPeriod(
                            defaultWarrantyPeriod:
                                defaultWarrantyController.text,
                          );
                        }
                      },
                      child: const SubmitButton(
                        heading: 'Save',
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
