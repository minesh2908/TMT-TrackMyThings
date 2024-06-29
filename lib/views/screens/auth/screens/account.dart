import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:warranty_tracker/routes/routes_names.dart';
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
    context.read<AuthBloc>().add(GetCurrentUserData());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        print('State - $State');
        if (state is AuthSuccessState) {
          Navigator.pushReplacementNamed(context, RoutesName.authScreen);
        }
        if (state is AuthFailureState) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Account Deletion Failed')),
          );
        }
        if (state is AccountDeletedState) {
          Navigator.pushReplacementNamed(context, RoutesName.authScreen);
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
                                Navigator.pop(context);
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
                  print(state.runtimeType);
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
                  if (state is UserDateFetchedSuccessfullyState) {
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
                                keyboardType: TextInputType.number,
                                maxLength: 10,
                                fieldName:
                                    AppLocalizations.of(context)!.phoneNumber,
                                controller: phoneController,
                                validator: (value) {
                                  if (value!.isNotEmpty) {
                                    if (value.length != 10) {
                                      return 'Phone Number must be of 10 digits';
                                    } else if (!RegExp(r'^[0-9]+$')
                                        .hasMatch(value)) {
                                      return '''Phone Number must contain only digits''';
                                    }
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
                                    print(state.userModel);
                                    context.read<AuthBloc>().add(
                                          UpdateUserAccountDetails(
                                            userModel:
                                                state.userModel!.copyWith(
                                              name: nameController.text.isEmpty
                                                  ? AppPrefHelper
                                                      .getDisplayName()
                                                  : nameController.text,
                                              phoneNumber:
                                                  phoneController.text.isEmpty
                                                      ? AppPrefHelper
                                                          .getPhoneNumber()
                                                      : phoneController.text,
                                            ),
                                          ),
                                        );
                                    context
                                        .read<AuthBloc>()
                                        .add(GetCurrentUserData());
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
            ),
          ),
        );
      },
    );
  }
}
