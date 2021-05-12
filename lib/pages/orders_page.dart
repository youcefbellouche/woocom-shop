import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:woocommerce_app/models/order.dart';
import 'package:woocommerce_app/provider/order_provider.dart';
import 'package:woocommerce_app/widgets/widget_order_item.dart';

class OrdersPage extends StatefulWidget {
  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  List<OrderModel> orders;

  @override
  void initState() {
    super.initState();
    var orderProvider = Provider.of<OrderProvider>(context, listen: false);
    orderProvider.fetchOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: new BoxDecoration(
              gradient: new LinearGradient(
                colors: [Color(0xff2ba9e1), Color(0xff0e71b8)],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              ),
            ),
          ),
          iconTheme: IconThemeData(color: Colors.white),
          centerTitle: true,
          brightness: Brightness.dark,
          elevation: 0,
          automaticallyImplyLeading: true,
          title: Text(
            'Raysel Shop',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xff2ba9e1), Color(0xff0e71b8)])),
            child:
                Consumer<OrderProvider>(builder: (context, ordersModel, child) {
              if (ordersModel.allOredrs != null &&
                  ordersModel.allOredrs.length > 0) {
                return _listView(context, ordersModel.allOredrs);
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            })));
  }

  Widget _listView(BuildContext context, List<OrderModel> order) {
    return ListView(
      children: [
        ListView.builder(
          itemCount: order.length,
          physics: ScrollPhysics(),
          padding: EdgeInsets.all(8),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(16),
              ),
              child: WidgetOrderItem(
                orderModel: order[index],
              ),
            );
          },
        )
      ],
    );
  }
}
