import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:shimmer/shimmer.dart';
import 'package:warranty_tracker/gen/assets.gen.dart';
import 'package:warranty_tracker/routes/routes_names.dart';
import 'package:warranty_tracker/service/calculate_date.dart';
import 'package:warranty_tracker/service/shared_prefrence.dart';
import 'package:warranty_tracker/util/extension.dart';
import 'package:warranty_tracker/views/components/side_nav_bar.dart';
import 'package:warranty_tracker/views/screens/add_product/bloc/product_bloc.dart';

class MyDashboard extends StatefulWidget {
  const MyDashboard({super.key});

  @override
  State<MyDashboard> createState() => _MyDashboardState();
}

class _MyDashboardState extends State<MyDashboard> {
  //notifier listener for fetching username from shared prefrence
  final userNameNotifier = ValueNotifier<String>('');
  late final FocusNode _focusNode;
  late final TextEditingController _controller;

  @override
  void initState() {
    _focusNode = FocusNode();
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: userNameNotifier,
      builder: (context, value, _) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            centerTitle: true,
            title: (_focusNode.hasFocus || _controller.text.isNotEmpty)
                ? TextField(
                    cursorColor: Colors.white,
                    focusNode: _focusNode,
                    controller: _controller,
                    decoration: InputDecoration.collapsed(
                      hintText: AppLocalizations.of(context)!.enterProductName,
                      hintStyle: const TextStyle(color: Colors.white),
                    ),
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    onChanged: (value) {
                      context
                          .read<ProductBloc>()
                          .add(SearchProductEvent(searchProductName: value));
                    },
                  )
                : Text(
                    '''${AppLocalizations.of(context)!.welcome} ${AppPrefHelper.getDisplayName()}''',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
            actions: [
              IconButton(
                onPressed: () {
                  if (!_focusNode.hasFocus) {
                    FocusScope.of(context).requestFocus(_focusNode);
                  }
                },
                icon: const Icon(
                  Icons.search,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          drawer: SizedBox(
            width: MediaQuery.of(context).size.width * 0.75,
            child: const SideNavBar(),
          ),
          drawerScrimColor: Theme.of(context).colorScheme.secondary,
          drawerEdgeDragWidth: 50,
          body: BlocConsumer<ProductBloc, ProductState>(
            listener: (context, state) {},
            builder: (context, state) {
              if (state is ProductSuccessState) {
                return Center(
                  child: state.productList.isEmpty
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 200,
                              width: 200,
                              child: Assets.images.emptyBox.image(),
                            ),
                            Text(
                              AppLocalizations.of(context)!.youHaveNotAdded,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.scrim,
                              ),
                            ),
                            Text(
                              AppLocalizations.of(context)!.clickToAdd,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.scrim,
                              ),
                            ),
                          ],
                        )
                      : Padding(
                          padding: const EdgeInsets.only(
                            top: 8,
                            left: 16,
                            right: 16,
                          ),
                          child: Column(
                            children: [
                              Expanded(
                                child: ListView.builder(
                                  itemCount: state.productList.length,
                                  itemBuilder: (context, index) {
                                    final productData =
                                        state.productList[index];
                                    final remainingTime =
                                        calculateDateDifference(
                                      productData.warrantyEndsDate!,
                                    );

                                    return Padding(
                                      padding: const EdgeInsets.only(
                                        top: 16,
                                      ),
                                      child: InkWell(
                                        onTap: () async {
                                          final scaffoldMessenger =
                                              ScaffoldMessenger.of(context);

                                          final result =
                                              await Navigator.pushNamed(
                                            context,
                                            RoutesName.updateProduct,
                                            arguments: productData,
                                          );
                                          // print('======== $result');
                                          if (result == 'updated') {
                                            scaffoldMessenger.showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  // context
                                                  //     .lang.productAddSuccess,
                                                  'Product Updated Succesfully!',
                                                ),
                                              ),
                                            );
                                          } else if (result == 'deleted') {
                                            scaffoldMessenger.showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  // AppLocalizations.of(context)!
                                                  //     .productDeleteSuccess,
                                                  'Product Deleted succesfully!',
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                        child: Container(
                                          height: 140,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.90,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(14),
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                          ),
                                          child: Row(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onSurface,
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: productData
                                                            .productImage !=
                                                        null
                                                    ? Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8),
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                          child: Image.network(
                                                            productData
                                                                .productImage!,
                                                            fit: BoxFit.cover,
                                                            height: 140,
                                                            width:
                                                                MediaQuery.of(
                                                                      context,
                                                                    )
                                                                        .size
                                                                        .width *
                                                                    0.30,
                                                          ),
                                                        ),
                                                      )
                                                    : Assets.images.noImage
                                                        .image(
                                                        fit: BoxFit.cover,
                                                      ),
                                              ),
                                              const SizedBox(
                                                width: 20,
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  vertical: 10,
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Flexible(
                                                      child: Text(
                                                        productData.productName
                                                                ?.truncate(
                                                              20,
                                                            ) ??
                                                            '',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .surface,
                                                          fontSize: 22,
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        '''Warranty ends on ${productData.warrantyEndsDate!.toDateTime()!.toFormattedDate}''',
                                                        maxLines: 1,
                                                        style: TextStyle(
                                                          color: Theme.of(
                                                            context,
                                                          ).colorScheme.surface,
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 12,
                                                    ),
                                                    Text(
                                                      remainingTime,
                                                      style: TextStyle(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .surface,
                                                        fontSize: 18,
                                                      ),
                                                    ),
                                                    LinearPercentIndicator(
                                                      padding: EdgeInsets.zero,
                                                      width: MediaQuery.of(
                                                            context,
                                                          ).size.width *
                                                          0.40,
                                                      lineHeight: 12,
                                                      percent:
                                                          calculateWarrantyPercentage(
                                                        productData
                                                            .purchasedDate!,
                                                        productData
                                                            .warrantyEndsDate!,
                                                      ),
                                                      barRadius:
                                                          const Radius.circular(
                                                        10,
                                                      ),
                                                      progressColor:
                                                          Theme.of(context)
                                                              .colorScheme
                                                              .onPrimary,
                                                      backgroundColor:
                                                          Theme.of(context)
                                                              .colorScheme
                                                              .surface,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                );
              } else if (state is ProductLoadingState) {
                return Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: ListView.builder(
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8),
                          child: Container(
                            height: 140,
                            width: MediaQuery.of(context).size.width * 0.90,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  height: 120,
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        height: 12,
                                      ),
                                      LinearPercentIndicator(
                                        padding: EdgeInsets.zero,
                                        width: MediaQuery.of(
                                              context,
                                            ).size.width *
                                            0.40,
                                        lineHeight: 12,
                                        percent: 0.2,
                                        barRadius: const Radius.circular(
                                          10,
                                        ),
                                        progressColor: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .surface,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              } else if (state is ProductFailureState) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 200,
                        width: 200,
                        child: Assets.images.emptyBox.image(),
                      ),
                      Text(
                        AppLocalizations.of(context)!.oops,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        AppLocalizations.of(context)!.retry,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                );
              } else {
                return const SizedBox();
              }
            },
          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.all(8),
            child: Transform.scale(
              scale: 1.2,
              child: FloatingActionButton(
                backgroundColor: Theme.of(context).colorScheme.onPrimary,
                onPressed: () async {
                  final result = await Navigator.pushNamed(
                    context,
                    RoutesName.addProduct,
                  );
                  if (!mounted) return;
                  //print('======== $result');
                  if (result == true) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Product Added Succesfully'),
                      ),
                    );
                  }
                },
                child: Icon(
                  Icons.add,
                  color: Theme.of(context).colorScheme.surface,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
