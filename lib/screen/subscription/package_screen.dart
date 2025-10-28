import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spinovo_app/component/custom_appbar.dart';
import 'package:spinovo_app/providers/order_provider.dart'; // If needed
import 'package:spinovo_app/providers/package_subscription.dart';
import 'package:spinovo_app/screen/subscription/subscripion_checkout.dart';
import 'package:spinovo_app/services/bottom_navigation.dart';
import 'package:spinovo_app/utiles/color.dart';
import 'package:spinovo_app/models/subscription_model.dart';
import '../../widget/button.dart';

class PackageScreen extends StatefulWidget {
  const PackageScreen({super.key});

  @override
  State<PackageScreen> createState() => _PackageScreenState();
}

class _PackageScreenState extends State<PackageScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<OrderProvider>(context, listen: false).fetchOrders();
      Provider.of<PackageSubscripionProvider>(
        context,
        listen: false,
      ).fetchSubscriptions();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const BottomNavigation(indexSet: 0),
          ),
        );
        return false;
      },
      child: Scaffold(
        backgroundColor: AppColor.bgColor,
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: CustomAppBar(title: "Packages", isBack: false),
        ),
        body: Consumer<PackageSubscripionProvider>(
          builder: (context, PackageSubscripionProvider, child) {
            if (PackageSubscripionProvider.isLoading) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColor.appbarColor,
                  ),
                ),
              );
            }
            if (PackageSubscripionProvider.errorMessage != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      PackageSubscripionProvider.errorMessage!,
                      style: const TextStyle(color: Colors.red, fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () =>
                          PackageSubscripionProvider.fetchSubscriptions(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }
            final subscriptions =
                PackageSubscripionProvider
                    .subscriptionModel
                    ?.data
                    .subscriptions ??
                [];
            if (subscriptions.isEmpty) {
              return const Center(
                child: Text(
                  'No packages available at the moment.',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: subscriptions.length,
              itemBuilder: (context, index) {
                final sub = subscriptions[index];
                return _buildSubscriptionSection(sub);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildSubscriptionSection(Subscription sub) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Row(
            children: [
              Icon(
                Icons.local_laundry_service,
                color: AppColor.textColor,
                size: 28,
              ),
              const SizedBox(width: 8),
              Text(
                sub.name,
                style: const TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: sub.plans.length,
          itemBuilder: (context, planIndex) {
            final plan = sub.plans[planIndex];
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              child: Card(
                elevation: 0.2,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.only(bottom: 16),
                child: ExpansionTile(
                  title: Text(
                    '${plan.validity} Days Validity',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  leading: Icon(
                    Icons.calendar_today,
                    color: AppColor.appbarColor,
                  ),
                  childrenPadding: const EdgeInsets.all(8.0),
                  expandedCrossAxisAlignment: CrossAxisAlignment.start,
                  children: plan.subPlans
                      .map((subPlan) => _buildSubPlanCard(sub, plan, subPlan))
                      .toList(),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSubPlanCard(Subscription sub, Plan plan, SubPlan subPlan) {
    return Card(
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${subPlan.clothes} Clothes',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${subPlan.discountRate}% Off',
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Price: ₹${subPlan.prices}',
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 4),
            Text(
              'Pickups: ${subPlan.noOfPickups}',
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 16),
            ContinueButton(
              height: 40,
              text: 'Buy Now',
              isValid: true,
              isLoading: false,
              onTap: () {
                Map<String, Object> buyPackage = {
                  'id': sub.id,
                  "name": sub.name,
                  "validity": plan.validity,
                  "clothes": subPlan.clothes,
                  "discount_rate": subPlan.discountRate,
                  "prices": subPlan.prices,
                  "no_of_pickups": subPlan.noOfPickups,
                };

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SubscriptionCheckoutScreen(buyPackage: buyPackage),
                  ),
                );

                // Provider.of<PackageSubscripionProvider>(
                //   context,
                //   listen: false,
                // ).buyPackage(packageDetails);
                // ScaffoldMessenger.of(context).showSnackBar(
                //   const SnackBar(content: Text('Package booked successfully!')),
                // );
              },
            ),
          ],
        ),
      ),
    );
  }
}
