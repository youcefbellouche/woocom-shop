import 'package:flutter/material.dart';
import 'package:woocommerce_app/api_service.dart';
import 'package:woocommerce_app/config.dart';
import 'package:woocommerce_app/models/order.dart';
import 'package:woocommerce_app/models/order_detail.dart';
import 'package:woocommerce_app/pages/base_page.dart';
import 'package:woocommerce_app/utils/widget_checkpoints.dart';
import 'package:woocommerce_app/models/cart_response_model.dart' as ListItems;

class OrderDetailsPage extends BasePage {
  int orderID;
  OrderDetailsPage({Key key, this.orderID}) : super(key: key);
  @override
  _OrderDetailsPageState createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends BasePageState<OrderDetailsPage> {
  APIService apiService;
  @override
  void initState() {
    super.initState();
    apiService = new APIService();
    print(this.widget.orderID);
  }

  @override
  Widget pageUI() {
    return new FutureBuilder(
      future: apiService.getOrderDetails(this.widget.orderID),
      builder: (BuildContext context,
          AsyncSnapshot<OrderDetailModel> orderDetailModel) {
        if (orderDetailModel.hasData) {
          return orderDetailUI(orderDetailModel.data);
        }

        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget orderDetailUI(OrderDetailModel orders) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "#${orders.orderId.toString()}",
            style: Theme.of(context).textTheme.labelHeading,
          ),
          Text(orders.orderDate.toString(),
              style: Theme.of(context).textTheme.labelText),
          SizedBox(
            height: 20,
          ),
          Text(
            "Livré à",
            style: Theme.of(context).textTheme.labelHeading,
          ),
          Text(orders.shipping.address1,
              style: Theme.of(context).textTheme.labelText),
          Text(orders.shipping.address2,
              style: Theme.of(context).textTheme.labelText),
          Text("${orders.shipping.city}, ${orders.shipping.country}",
              style: Theme.of(context).textTheme.labelText),
          Text("Les données", style: Theme.of(context).textTheme.labelText),
          SizedBox(
            height: 20,
          ),
          Divider(
            color: Colors.grey,
          ),
          SizedBox(
            height: 5,
          ),
          CheckPoints(
            checkedTill: 0,
            checkPoints: ["En traitement", "livraison", "Livré"],
            checkPointFilledColor: Colors.blue,
          ),
          Divider(
            color: Colors.grey,
          ),
          _listOrderItem(orders),
          Divider(
            color: Colors.grey,
          ),
          _itemTotal("Objet total", "${orders.itemTotalAmount}"),
          _itemTotal("Frais d'expédition", "${orders.shippingTotal}"),
          _itemTotal("Payé", "${orders.totalAmount}"),
        ],
      ),
    );
  }

  Widget _listOrderItem(OrderDetailModel order) {
    return ListView.builder(
      itemCount: order.lineItems.length,
      physics: ScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return _productItems(order.lineItems[index]);
      },
    );
  }

  Widget _productItems(LineItems product) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.all(2),
      onTap: () {
        print(product.productId);
      },
      title: new Text(product.productName.toString()),
      subtitle: Padding(
        padding: EdgeInsets.all(1),
        child: new Text("Qté: ${product.quantity}"),
      ),
      trailing: new Text("${Config.currency}${product.totalAmount}"),
    );
  }

  Widget _itemTotal(String label, String value, {TextStyle textStyle}) {
    return ListTile(
      dense: true,
      visualDensity: VisualDensity(horizontal: 0, vertical: -4),
      contentPadding: EdgeInsets.fromLTRB(2, -10, 2, -10),
      title: new Text(
        label,
        style: textStyle,
      ),
      trailing: new Text("${Config.currency}$value"),
    );
  }
}

extension CustomStyles on TextTheme {
  TextStyle get labelHeading {
    return TextStyle(
        fontSize: 16, color: Colors.blue, fontWeight: FontWeight.bold);
  }

  TextStyle get labelText {
    return TextStyle(
        fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold);
  }
}
