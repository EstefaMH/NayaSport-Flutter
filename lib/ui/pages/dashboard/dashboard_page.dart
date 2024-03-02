import 'package:flutter/material.dart';
import 'package:prueba/ui/pages/dashboard/dashboard_add_product/dashboard_add_product.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return const DashboardAddProduct();
  }
}