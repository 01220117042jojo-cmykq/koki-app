abstract class OnboardingStates {}
class OnboardingInitialState extends OnboardingStates {}
class OnboardingPageChangedState extends OnboardingStates{
  final int pageIndex ;
  OnboardingPageChangedState({ required this.pageIndex});
}