import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:shimmer/shimmer.dart';
import 'package:track_my_things/gen/assets.gen.dart';
import 'package:track_my_things/l10n/l10n.dart';
import 'package:track_my_things/routes/routes_names.dart';
import 'package:track_my_things/service/calculate_date.dart';
import 'package:track_my_things/service/shared_prefrence.dart';
import 'package:track_my_things/util/extension.dart';
import 'package:track_my_things/views/components/button.dart';
import 'package:track_my_things/views/components/side_nav_bar.dart';
import 'package:track_my_things/views/screens/add_product/bloc/product_bloc.dart';
import 'package:track_my_things/views/screens/fetch_image_data/bloc/fetch_image_data_bloc.dart';

class MyDashboard extends StatefulWidget {
  const MyDashboard({super.key, this.message});
  final String? message;
  @override
  State<MyDashboard> createState() => _MyDashboardState();
}

class _MyDashboardState extends State<MyDashboard> {
  //notifier listener for fetching username from shared prefrence
  final userNameNotifier = ValueNotifier<String>('');
  late final FocusNode _focusNode;
  late final TextEditingController _controller;

  //radio value
  final selectedValue = ValueNotifier<String>('1');
  @override
  void initState() {
    super.initState();

    _focusNode = FocusNode();
    _controller = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _controller.addListener(() {
      context
          .read<ProductBloc>()
          .add(SearchProductEvent(searchProductName: _controller.text));
    });
    if (widget.message != null && widget.message!.isNotEmpty) {
      Future.delayed(const Duration(seconds: 1), () {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(widget.message!)));
      });
    }
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
                    autofocus: true,
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
                  )
                : Text(
                    '''${AppLocalizations.of(context)!.welcome} ${AppPrefHelper.getDisplayName()}''',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
            actions: [
              if (_focusNode.hasFocus)
                IconButton(
                  onPressed: () {
                    _controller.clear();
                    _focusNode.unfocus();
                  },
                  icon: const Icon(
                    Icons.cancel,
                    color: Colors.white,
                  ),
                )
              else
                IconButton(
                  onPressed: () {
                    if (!_focusNode.hasFocus) {
                      Future.delayed(
                          const Duration(
                            microseconds: 50,
                          ), () {
                        FocusScope.of(context).requestFocus(_focusNode);
                      });
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
                            //Text(_controller.text),
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
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              InkWell(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        showModalBottomSheet<dynamic>(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                left: 8,
                                                right: 8,
                                              ),
                                              child: SizedBox(
                                                height: 300,
                                                width: double.infinity,
                                                child: ValueListenableBuilder(
                                                  valueListenable:
                                                      selectedValue,
                                                  builder: (context, value, _) {
                                                    return Column(
                                                      children: [
                                                        const SizedBox(
                                                          height: 20,
                                                        ),
                                                        const Text(
                                                          'Filter Product',
                                                          style: TextStyle(
                                                            fontSize: 24,
                                                          ),
                                                        ),
                                                        const Divider(
                                                          indent: 12,
                                                          endIndent: 12,
                                                        ),
                                                        RadioListTile(
                                                          contentPadding:
                                                              EdgeInsets.zero,
                                                          title: const Text(
                                                            'All Products',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          ),
                                                          value: '1',
                                                          groupValue: value,
                                                          onChanged: (value) {
                                                            selectedValue
                                                                    .value =
                                                                value
                                                                    .toString();
                                                          },
                                                        ),
                                                        RadioListTile(
                                                          contentPadding:
                                                              EdgeInsets.zero,
                                                          title: const Text(
                                                            '''Product under warranty''',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          ),
                                                          value: '2',
                                                          groupValue: value,
                                                          onChanged: (value) {
                                                            selectedValue
                                                                    .value =
                                                                value
                                                                    .toString();
                                                          },
                                                        ),
                                                        RadioListTile(
                                                          contentPadding:
                                                              EdgeInsets.zero,
                                                          title: const Text(
                                                            '''Warranty Expired Product''',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          ),
                                                          value: '3',
                                                          groupValue: value,
                                                          onChanged: (value) {
                                                            selectedValue
                                                                    .value =
                                                                value
                                                                    .toString();
                                                          },
                                                        ),
                                                        InkWell(
                                                          onTap: () {
                                                            context
                                                                .read<
                                                                    ProductBloc>()
                                                                .add(
                                                                  GetAllProductEvent(
                                                                    filterValue:
                                                                        selectedValue
                                                                            .value,
                                                                  ),
                                                                );
                                                            AppPrefHelper
                                                                .setFilterValue(
                                                              filterValue:
                                                                  selectedValue
                                                                      .value,
                                                            );

                                                            Navigator.pop(
                                                              context,
                                                            );
                                                          },
                                                          child:
                                                              const SubmitButton(
                                                            heading:
                                                                'Apply Filter',
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      child: Icon(
                                        Icons.sort,
                                        size: 20,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        showModalBottomSheet<dynamic>(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                left: 8,
                                                right: 8,
                                              ),
                                              child: SizedBox(
                                                height: 300,
                                                width: double.infinity,
                                                child: ValueListenableBuilder(
                                                  valueListenable:
                                                      selectedValue,
                                                  builder: (context, value, _) {
                                                    return Column(
                                                      children: [
                                                        const SizedBox(
                                                          height: 20,
                                                        ),
                                                        const Text(
                                                          'Filter Product',
                                                          style: TextStyle(
                                                            fontSize: 24,
                                                          ),
                                                        ),
                                                        const Divider(
                                                          indent: 12,
                                                          endIndent: 12,
                                                        ),
                                                        RadioListTile(
                                                          contentPadding:
                                                              EdgeInsets.zero,
                                                          title: Text(
                                                            context.lang
                                                                .allProducts,
                                                            style:
                                                                const TextStyle(
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          ),
                                                          value: '1',
                                                          groupValue: value,
                                                          onChanged: (value) {
                                                            selectedValue
                                                                    .value =
                                                                value
                                                                    .toString();
                                                          },
                                                        ),
                                                        RadioListTile(
                                                          contentPadding:
                                                              EdgeInsets.zero,
                                                          title: Text(
                                                            context.lang
                                                                .productUnderWarranty,
                                                            style:
                                                                const TextStyle(
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          ),
                                                          value: '2',
                                                          groupValue: value,
                                                          onChanged: (value) {
                                                            selectedValue
                                                                    .value =
                                                                value
                                                                    .toString();
                                                          },
                                                        ),
                                                        RadioListTile(
                                                          contentPadding:
                                                              EdgeInsets.zero,
                                                          title: Text(
                                                            context.lang
                                                                .warrantyExpiredProduct,
                                                            style:
                                                                const TextStyle(
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          ),
                                                          value: '3',
                                                          groupValue: value,
                                                          onChanged: (value) {
                                                            selectedValue
                                                                    .value =
                                                                value
                                                                    .toString();
                                                          },
                                                        ),
                                                        InkWell(
                                                          onTap: () {
                                                            context
                                                                .read<
                                                                    ProductBloc>()
                                                                .add(
                                                                  GetAllProductEvent(
                                                                    filterValue:
                                                                        selectedValue
                                                                            .value,
                                                                  ),
                                                                );
                                                            AppPrefHelper
                                                                .setFilterValue(
                                                              filterValue:
                                                                  selectedValue
                                                                      .value,
                                                            );

                                                            Navigator.pop(
                                                              context,
                                                            );
                                                          },
                                                          child:
                                                              const SubmitButton(
                                                            heading:
                                                                'Apply Filter',
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      child: Text(
                                        context.lang.filter,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
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
                                            RoutesName.productDetails,
                                            arguments: productData,
                                          );
                                          // print('======== $result');
                                          if (result == 'updated') {
                                            scaffoldMessenger.showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  '''Product Updated Successfully!''',
                                                ),
                                              ),
                                            );
                                          } else if (result == 'deleted') {
                                            scaffoldMessenger.showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  '''Product Deleted successfully!''',
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
                                                      BorderRadius.circular(
                                                    12,
                                                  ),
                                                ),
                                                child: productData
                                                            .productImage !=
                                                        null
                                                    ? Hero(
                                                        tag: 'productImage',
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8),
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                              12,
                                                            ),
                                                            child:
                                                                Image.network(
                                                              productData
                                                                  .productImage!,
                                                              fit: BoxFit.cover,
                                                              height: 140,
                                                              width: MediaQuery
                                                                      .of(
                                                                    context,
                                                                  ).size.width *
                                                                  0.30,
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    : Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8),
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                            12,
                                                          ),
                                                          child: Assets
                                                              .images.noImage
                                                              .image(
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
                                                          color: Theme.of(
                                                            context,
                                                          ).colorScheme.surface,
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
                                                        color: Theme.of(
                                                          context,
                                                        ).colorScheme.surface,
                                                        fontSize: 18,
                                                      ),
                                                    ),
                                                    TweenAnimationBuilder<
                                                        double>(
                                                      tween: Tween<double>(
                                                        begin: 0,
                                                        end:
                                                            calculateWarrantyPercentage(
                                                          productData
                                                              .purchasedDate!,
                                                          productData
                                                              .warrantyEndsDate!,
                                                        ),
                                                      ),
                                                      duration: const Duration(
                                                        seconds: 1,
                                                      ),
                                                      builder: (
                                                        BuildContext context,
                                                        double percentage,
                                                        Widget? child,
                                                      ) {
                                                        return LinearPercentIndicator(
                                                          padding:
                                                              EdgeInsets.zero,
                                                          width: MediaQuery.of(
                                                                context,
                                                              ).size.width *
                                                              0.40,
                                                          lineHeight: 12,
                                                          percent: percentage,
                                                          barRadius:
                                                              const Radius
                                                                  .circular(
                                                            10,
                                                          ),
                                                          progressColor:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .onPrimary,
                                                          backgroundColor:
                                                              Theme.of(
                                                            context,
                                                          ).colorScheme.surface,
                                                        );
                                                      },
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
              } else if (state is NoFilterProductAvailableState) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 120,
                      width: MediaQuery.sizeOf(context).width,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 8,
                          left: 8,
                          right: 8,
                        ),
                        child: Column(
                          children: [
                            if (selectedValue.value == '3')
                              Text(
                                context.lang.noWarrantyEndItem,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Theme.of(context).colorScheme.surface,
                                ),
                              )
                            else if (selectedValue.value == '2')
                              Text(
                                context.lang.noProductUnderWarranty,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Theme.of(context).colorScheme.surface,
                                ),
                              ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () {
                                    context.read<ProductBloc>().add(
                                          GetAllProductEvent(
                                            filterValue: '1',
                                          ),
                                        );
                                    selectedValue.value = '1';
                                    AppPrefHelper.setFilterValue(
                                      filterValue: selectedValue.value,
                                    );
                                  },
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.95,
                                    height: 40,
                                    child: SubmitButton(
                                      heading: context.lang.cancel,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
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
                  context.read<FetchImageDataBloc>().add(ChangeStateEvent());
                  if (!mounted) return;
                  //print('======== $result');
                  if (result == true) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Product Added Successfully'),
                      ),
                    );
                  } else {}
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
