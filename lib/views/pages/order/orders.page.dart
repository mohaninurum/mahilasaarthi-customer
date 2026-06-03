import 'package:flutter/material.dart';
import 'package:mahilasaarthi/constants/app_colors.dart';
import 'package:mahilasaarthi/services/order.service.dart';
import 'package:mahilasaarthi/utils/ui_spacer.dart';
import 'package:mahilasaarthi/view_models/orders.vm.dart';
import 'package:mahilasaarthi/widgets/base.page.dart';
import 'package:mahilasaarthi/widgets/custom_list_view.dart';
import 'package:mahilasaarthi/widgets/list_items/order.list_item.dart';
import 'package:mahilasaarthi/widgets/list_items/taxi_order.list_item.dart';
import 'package:mahilasaarthi/widgets/states/empty.state.dart';
import 'package:mahilasaarthi/widgets/states/error.state.dart';
import 'package:mahilasaarthi/widgets/states/order.empty.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({Key? key}) : super(key: key);

  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage>
    with AutomaticKeepAliveClientMixin<OrdersPage>, WidgetsBindingObserver {
  //
  late OrdersViewModel vm;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      vm.fetchMyOrders();
    }
  }

  @override
  Widget build(BuildContext context) {
    vm = OrdersViewModel(context);
    super.build(context);
    return BasePage(
      appBarColor: AppColor.primaryColor,
      title:  Text("My Orders",style: TextStyle(color: Colors.white,fontSize: 22,fontWeight: FontWeight.bold),),
      showAppBar: false,
      body: ViewModelBuilder<OrdersViewModel>.reactive(
        viewModelBuilder: () => vm,
        onViewModelReady: (vm) => vm.initialise(),
        builder: (context, vm, child) {
          return VStack(
            [
              //

              Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [Color(0xffC70774),Color(0xff610339)],begin:Alignment.bottomLeft ,end:  Alignment.topRight)
                ),height: 80,width: double.infinity,child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
                SizedBox(height: 35,),
                "My Orders".tr().text.xl2.semiBold.white.make(),
              ],),),

              SizedBox(height: 15,),
              //
              vm.isAuthenticated()
                  ? CustomListView(
                padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                      canRefresh: true,
                      canPullUp: true,
                      refreshController: vm.refreshController,
                      onRefresh: vm.fetchMyOrders,
                      onLoading: () =>
                          vm.fetchMyOrders(initialLoading: false),
                      isLoading: vm.isBusy,
                      dataSet: vm.orders,
                      hasError: vm.hasError,
                      errorWidget: LoadingError(
                        onrefresh: vm.fetchMyOrders,
                      ),
                      //
                      emptyWidget: EmptyOrder(),
                      itemBuilder: (context, index) {
                        //
                        final order = vm.orders[index];
                        //for taxi tye of order
                        if (order.taxiOrder != null) {
                          return TaxiOrderListItem(
                            order: order,
                            orderPressed: () => vm.openOrderDetails(order),
                          );
                        }
                        return OrderListItem(
                          order: order,
                          orderPressed: () => vm.openOrderDetails(order),
                          onPayPressed: () =>
                              OrderService.openOrderPayment(order, vm),
                        );
                      },
                      separatorBuilder: (context, index) =>
                          UiSpacer.verticalSpace(space: 2),
                    ).expand()
                  : EmptyState(
                      auth: true,
                      showAction: true,
                      actionPressed: vm.openLogin,
                    ).py12().centered().expand(),
            ],
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
