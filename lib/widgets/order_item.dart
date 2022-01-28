import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../providers/order_provider.dart' as ord;

class OrderItem extends StatefulWidget {
  final ord.OrderItem order;
  OrderItem(this.order);

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var expanded = false;
  @override
  Widget build(BuildContext context) {

    return Card(
      margin: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text(
                  '\$${widget.order.amount}',
              style: TextStyle(
                fontWeight: FontWeight.bold
              ),),
            subtitle: Text(
              DateFormat(
                  'dd/mm/yyyy hh:mm').format(widget.order.dateTime),
            ),
            trailing: IconButton(
              icon: Icon(
                  expanded ? Icons.expand_less : Icons.expand_more), onPressed: () {
              setState(() {
                expanded = !expanded;
              });
            },),),
            if (expanded) Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              height: min(widget.order.products.length * 20.0 + 10, 100),
            child: ListView(
              children: widget.order.products.map((prod) =>
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
              Text(prod.title,
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold),),
              Text(
                '${prod.quantity}x \$${prod.price}', style:
              TextStyle(
                fontSize: 18,
                color: Colors.purple,
              ),)

            ],)).toList(),),)
          ],
        ),
    );
  }
}
