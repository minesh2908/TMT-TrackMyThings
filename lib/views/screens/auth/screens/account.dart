import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:warranty_tracker/modal/user_model.dart';
import 'package:warranty_tracker/service/shared_prefrence.dart';
import 'package:warranty_tracker/views/components/button.dart';
import 'package:warranty_tracker/views/components/input_field_form.dart';
import 'package:warranty_tracker/views/screens/auth/bloc/auth_bloc.dart';

class AccountDetails extends StatefulWidget {
  const AccountDetails({super.key});

  @override
  State<AccountDetails> createState() => _AccountDetailsState();
}

class _AccountDetailsState extends State<AccountDetails> {
  TextEditingController nameController =
      TextEditingController(text: AppPrefHelper.getDisplayName());
  TextEditingController phoneController =
      TextEditingController(text: AppPrefHelper.getPhoneNumber());

  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccessState) {
          Navigator.pushNamed(context, '/');
        }
        if (state is AuthFailureState) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Account Deleted Successfully')),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            leading: const BackButton(),
            elevation: 2,
            title: Text(
              AppLocalizations.of(context)!.account,
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
                          title: const Text('Delete Account'),
                          content: const Text(
                            '''As you delete your account all the data related to it will also be deleted. This Process can not be undone. Are you sure you want to delete your account?''',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSecondaryFixedVariant,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                context.read<AuthBloc>().add(
                                      DeleteAccount(),
                                    );
                              },
                              child: Text(
                                'Delete',
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
            child: Center(
              child: BlocConsumer<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is AccountUpdatedState) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Account Updated Successfully',
                        ),
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  return Column(
                    children: [
                      Text(
                        AppPrefHelper.getEmail(),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            InputFieldForm(
                              fieldName: AppLocalizations.of(context)!.name,
                              controller: nameController,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            InputFieldForm(
                              fieldName:
                                  AppLocalizations.of(context)!.phoneNumber,
                              controller: phoneController,
                              validator: (value) {
                                if (value?.length != 10) {
                                  return 'Phone Number must be of 10 digit';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            InkWell(
                              onTap: () async {
                                if (_formKey.currentState!.validate()) {
                                  context.read<AuthBloc>().add(
                                        UpdateUserAccountDetails(
                                          userModel: UserModel(
                                            email: AppPrefHelper.getEmail(),
                                            userId: AppPrefHelper.getUID(),
                                            name: nameController.text.isEmpty
                                                ? AppPrefHelper.getDisplayName()
                                                : nameController.text,
                                            phoneNumber: phoneController
                                                    .text.isEmpty
                                                ? AppPrefHelper.getPhoneNumber()
                                                : phoneController.text,
                                          ),
                                        ),
                                      );
                                  if (nameController.text.isNotEmpty) {
                                    await AppPrefHelper.setDisplayName(
                                      displayName: nameController.text,
                                    );
                                  }

                                  if (phoneController.text.isNotEmpty) {
                                    await AppPrefHelper.setPhoneNumber(
                                      phoneNumber: phoneController.text,
                                    );
                                  }
                                }
                              },
                              child: state.runtimeType == AuthLoadingState
                                  ? const CircularProgressIndicator()
                                  : SubmitButton(
                                      heading: AppLocalizations.of(context)!
                                          .updateAccount,
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
