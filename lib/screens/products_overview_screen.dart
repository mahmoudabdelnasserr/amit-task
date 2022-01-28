import 'package:flutter/material.dart';
import 'package:new_app/providers/cart_provider.dart';
import 'package:new_app/providers/products_provider.dart';
import 'package:new_app/screens/cart_screen.dart';
import 'package:new_app/widgets/app_drawer.dart';
import 'package:new_app/widgets/product_grid.dart';
import 'package:provider/provider.dart';
import '../widgets/badge.dart';


enum FilterOptions {
  Favorites,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showOnlyFavorites = false;
  var _isInit = true;
  var _isLoading = false;

  @override
  void setState(VoidCallback fn) {
    // Future.delayed(Duration.zero).then((_){
    //   Provider.of<Products>(context).fetchAndSetProduct();
    //   });
    super.setState(fn);
  }


  @override
  void didChangeDependencies() {
    if (_isInit){
      setState(() {
        _isLoading = true;
      });

      Provider.of<Products>(context).fetchAndSetProduct().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MyShop', style: TextStyle(color: Colors.white),),
        actions: <Widget>[
          PopupMenuButton(
            color: Colors.white,
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.Favorites) {
                  _showOnlyFavorites = true;
                } else {
                  _showOnlyFavorites = false;
                }
              });
            },
            icon: Icon(
              Icons.more_vert,
              color: Colors.white,
            ),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Only Favorites'),
                value: FilterOptions.Favorites,
              ),
              PopupMenuItem(
                child: Text('Show All'),
                value: FilterOptions.All,
              ),
            ],
          ),
          Consumer<Cart>(
            builder: (_, cart, ch) => Badge(
              child: IconButton(
              icon: Icon(
              Icons.shopping_cart,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
              ),
              value: cart.itemsCount.toString(), color: Colors.red,
            ),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: _isLoading ? Center(
        child: CircularProgressIndicator(),)
          : ProductsGrid(_showOnlyFavorites),
    );
  }
}
