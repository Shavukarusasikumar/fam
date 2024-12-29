import 'package:fam/presentation/bloc/card/card_bloc.dart';
import 'package:fam/presentation/bloc/card/card_event.dart';
import 'package:fam/presentation/bloc/card/card_state.dart';
import 'package:fam/presentation/screens/home/widgets/card_group_widget.dart';
import 'package:fam/presentation/screens/widgets/loading_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.grey[100],
        title:  Image(
          image: const AssetImage('assets/images/fampaylogo.png'),
          height: 25.h,
          width: 90.w,
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: RefreshIndicator(
          color: Colors.black,
          backgroundColor: Colors.white,
          onRefresh: () async {
            context.read<CardBloc>().add(LoadCards());
          },
          child: BlocBuilder<CardBloc, CardState>(
            builder: (context, state) {
              if (state is CardLoading) {
                return const LoadingShimmer();
              }

              if (state is CardLoaded) {
                return ListView.builder(
                  itemCount: state.cardGroups.length,
                  itemBuilder: (context, index) {
                    return CardGroupWidget(
                      cardGroup: state.cardGroups[index],
                      prefs: context.read<CardBloc>().prefs,
                    );
                  },
                );
              }
              if (state is CardError) {
                return Center(child: Text(state.message));
              }
              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }
}
