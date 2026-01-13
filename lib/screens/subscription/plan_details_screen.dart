import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swap2godriver/bloc/subscription_bloc.dart';
import 'package:swap2godriver/repo/subscription_repo.dart';
import 'package:swap2godriver/themes/app_colors.dart';
import 'package:swap2godriver/screens/wallet/payment_webview_screen.dart';
import 'package:swap2godriver/widget/btn.dart';

class PlanDetailsScreen extends StatelessWidget {
  final int planId;

  const PlanDetailsScreen({super.key, required this.planId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          SubscriptionBloc(subscriptionRepository: SubscriptionRepository())
            ..add(LoadPlanDetails(planId: planId)),
      child: const _PlanDetailsView(),
    );
  }
}

class _PlanDetailsView extends StatelessWidget {
  const _PlanDetailsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Plan Details',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: BlocConsumer<SubscriptionBloc, SubscriptionState>(
        listener: (context, state) {
          if (state is PaymentInitialized) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PaymentWebViewScreen(
                  paymentUrl: state.paymentData.paymentUrl,
                ),
              ),
            );
          } else if (state is SubscriptionError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is SubscriptionLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PlanDetailsLoaded) {
            final plan = state.plan;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    plan.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${plan.currency} ${plan.amount} / ${plan.interval}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.backgroundColor,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Description',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    plan.description ?? 'No description available',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Features',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildFeatureRow(
                    Icons.battery_charging_full,
                    '${plan.maxBatteries} Max Batteries',
                  ),
                  if (plan.maxSwapsPerMonth != null)
                    _buildFeatureRow(
                      Icons.swap_calls,
                      '${plan.maxSwapsPerMonth} Swaps per month',
                    ),
                  _buildFeatureRow(
                    Icons.star,
                    plan.priorityAccess ? 'Priority Access' : 'Standard Access',
                  ),
                  _buildFeatureRow(
                    Icons.local_shipping,
                    plan.freeDelivery ? 'Free Delivery' : 'Standard Delivery',
                  ),
                  const Spacer(),
                  Btn(onPressed: (){
                    context.read<SubscriptionBloc>().add(
                          InitializePayment(planId: plan.id),
                        );
                  }, text: 'Subscribe Now')
                ],
              ),
            );
          }
          return const Center(child: Text('Failed to load plan details'));
        },
      ),
    );
  }

  Widget _buildFeatureRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: AppColors.backgroundColor, size: 24),
          const SizedBox(width: 12),
          Text(text, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
