import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:koki/domain/entities/user_profile_entity.dart';
import 'package:koki/features/profile/widgets/guest_profile_body.dart';
import 'package:koki/features/profile/widgets/user_profile_body.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'cubit/profile_cubit.dart';
import 'cubit/profile_states.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static final UserProfileEntity _dummyProfile = UserProfileEntity(
    name: 'Placeholder Profile Name',
    email: 'user.placeholder@example.com',
  );

  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().getProfileData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: BlocBuilder<ProfileCubit, ProfileStates>(
        builder: (context, state) {
          if (state is ProfileLoadingState) {
            return Skeletonizer(
              enabled: true,
              child: UserProfileBody(userProfile: _dummyProfile),
            );
          } else if (state is ProfileAuthenticatedState) {
            return Skeletonizer(
              enabled: false,
              child: UserProfileBody(userProfile: state.userProfile),
            );
          } else if (state is ProfileUnauthenticatedState) {
            return const GuestProfileBody();
          } else if (state is ProfileErrorState) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}