import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:track_my_things/service/shared_prefrence.dart';
import 'package:track_my_things/util/permission.dart';
import 'package:track_my_things/views/components/button.dart';
import 'package:track_my_things/views/components/input_field_form.dart';
import 'package:track_my_things/views/screens/add_product/bloc/product_bloc.dart';
import 'package:track_my_things/views/screens/auth/bloc/auth_bloc.dart';

class GeneralSettings extends StatefulWidget {
  const GeneralSettings({super.key});

  @override
  State<GeneralSettings> createState() => _GeneralSettingsState();
}

class _GeneralSettingsState extends State<GeneralSettings> {
  @override
  void initState() {
    context.read<AuthBloc>().add(GetCurrentUserData());
    checkNotification();
    super.initState();
  }

  final defaultWarrantyController =
      TextEditingController(text: AppPrefHelper.getDefaultWarrantyPeriod());

  final _formKey = GlobalKey<FormState>();
  final sortByNotifier =
      ValueNotifier<String>(AppPrefHelper.getSortProductBy());

  bool _isNotificationOn = false;
  Future<void> checkNotification() async {
    final isOn = await isNotificationOn();
    setState(() {
      _isNotificationOn = isOn;
    });
  }

  @override
  Widget build(BuildContext context) {
    final appLocalization = AppLocalizations.of(context)!;
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        print(state.runtimeType);
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
          body: BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AccountUpdatedState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Settings Updated Successfully',
                    ),
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state is UserDateFetchedSuccessfullyState) {
                return Padding(
                  padding: const EdgeInsets.all(8),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          appLocalization.sortItemBy,
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
                                border:
                                    Border.all(color: const Color(0xFFC1CDF5)),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
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
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
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
                              return appLocalization
                                  .defaultWarrantyCanNotBeEmpty;
                            }
                            return null;
                          },
                          fieldName: appLocalization.defaultWarrantyPeriod,
                          controller: defaultWarrantyController,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              appLocalization.allowNotification,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                            Switch(
                              trackColor:
                                  WidgetStateProperty.resolveWith((states) {
                                if (states.contains(WidgetState.selected)) {
                                  return Theme.of(context)
                                      .colorScheme
                                      .primary; // track color when switch is true
                                } else {
                                  return Colors
                                      .grey; // track color when switch is false
                                }
                              }),
                              thumbColor:
                                  WidgetStateProperty.resolveWith((states) {
                                if (states.contains(WidgetState.selected)) {
                                  return Colors
                                      .white; // thumb color when switch is true
                                } else {
                                  return Colors
                                      .white; // thumb color when switch is false
                                }
                              }),
                              value: _isNotificationOn,
                              onChanged: (value) async {
                                if (value) {
                                  await requestNotificationPermission();
                                } else {
                                  await stopNotificationPermission();
                                }
                                setState(() {
                                  _isNotificationOn = value;
                                });
                              },
                            ),
                          ],
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
                                context.read<ProductBloc>().add(
                                      GetAllProductEvent(
                                        filterValue:
                                            AppPrefHelper.getFilterValue(),
                                      ),
                                    );
                                context.read<AuthBloc>().add(
                                      UpdateUserAccountDetails(
                                        userModel: state.userModel!.copyWith(
                                          defaultWarrantyPeriod:
                                              defaultWarrantyController.text,
                                          sortItemBy:
                                              AppPrefHelper.getSortProductBy(),
                                        ),
                                      ),
                                    );
                                context
                                    .read<AuthBloc>()
                                    .add(GetCurrentUserData());

                                await AppPrefHelper.setDefaultWarrantyPeriod(
                                  defaultWarrantyPeriod:
                                      defaultWarrantyController.text,
                                );
                                await checkNotification();
                              }
                            },
                            child: SubmitButton(
                              heading: appLocalization.save,
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              } else if (state is AuthLoadingState) {
                return const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              return const SizedBox();
            },
          ),
        );
      },
    );
  }
}
