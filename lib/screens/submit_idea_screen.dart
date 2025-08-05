import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pgagi_assign/blocs/startup_bloc.dart';
import 'package:pgagi_assign/blocs/startup_event.dart';
import 'package:pgagi_assign/blocs/startup_state.dart';
import 'package:pgagi_assign/constants/app_constants.dart';
import 'package:pgagi_assign/utils/app_navigation.dart';
import 'package:pgagi_assign/widgets/common_widgets.dart';

class SubmitIdeaScreen extends StatefulWidget {
  const SubmitIdeaScreen({super.key});

  @override
  State<SubmitIdeaScreen> createState() => _SubmitIdeaScreenState();
}

class _SubmitIdeaScreenState extends State<SubmitIdeaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _taglineController = TextEditingController();
  final _descriptionController = TextEditingController();

  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _taglineController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a startup name';
    }
    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }
    if (value.trim().length > 50) {
      return 'Name must be less than 50 characters';
    }
    return null;
  }

  String? _validateTagline(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a tagline';
    }
    if (value.trim().length < 10) {
      return 'Tagline must be at least 10 characters';
    }
    if (value.trim().length > 100) {
      return 'Tagline must be less than 100 characters';
    }
    return null;
  }

  String? _validateDescription(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a description';
    }
    if (value.trim().length < 50) {
      return 'Description must be at least 50 characters';
    }
    if (value.trim().length > 1000) {
      return 'Description must be less than 1000 characters';
    }
    return null;
  }

  void _submitIdea() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
      });

      context.read<StartupBloc>().add(
        SubmitIdea(
          name: _nameController.text.trim(),
          tagline: _taglineController.text.trim(),
          description: _descriptionController.text.trim(),
        ),
      );
    }
  }

  void _clearForm() {
    _nameController.clear();
    _taglineController.clear();
    _descriptionController.clear();
    _formKey.currentState?.reset();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<StartupBloc, StartupState>(
      listener: (context, state) {
        if (state is IdeaSubmitted) {
          setState(() {
            _isSubmitting = false;
          });

          Fluttertoast.showToast(
            msg:
                "🎉 Idea submitted successfully! AI Rating: ${state.submittedIdea.aiRating}/100",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
          );

          _clearForm();

          // Show success dialog
          _showSuccessDialog(state.submittedIdea.aiRating);
        } else if (state is StartupError) {
          setState(() {
            _isSubmitting = false;
          });

          Fluttertoast.showToast(
            msg: "Error: ${state.message}",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
          );
        }
      },
      child: LoadingOverlay(
        isLoading: _isSubmitting,
        message: "🤖 AI is analyzing your idea...\nThis may take a few moments",
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.mediumSpacing),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header Section
                  Container(
                    padding: const EdgeInsets.all(AppConstants.largeSpacing),
                    margin: const EdgeInsets.only(
                      bottom: AppConstants.largeSpacing,
                    ),
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(
                        AppConstants.largeRadius,
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.lightbulb,
                          size: 48,
                          color: Colors.white,
                        ).animate().scale(duration: 600.ms),
                        const SizedBox(height: AppConstants.mediumSpacing),
                        Text(
                          'Share Your Startup Idea',
                          style: AppTextStyles.heading2.copyWith(
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ).animate().fadeIn(delay: 200.ms),
                        const SizedBox(height: AppConstants.smallSpacing),
                        Text(
                          'Get AI feedback and let the community vote!',
                          style: AppTextStyles.body1.copyWith(
                            color: Colors.white.withOpacity(0.9),
                          ),
                          textAlign: TextAlign.center,
                        ).animate().fadeIn(delay: 400.ms),
                      ],
                    ),
                  ),

                  // Form Fields
                  CustomTextField(
                    label: 'Startup Name *',
                    hint: 'e.g., EcoDelivery, TechTutor, FoodieBot',
                    controller: _nameController,
                    validator: _validateName,
                    prefixIcon: const Icon(Icons.business),
                  ).animate().slideX(delay: 100.ms, begin: -0.3),

                  const SizedBox(height: AppConstants.largeSpacing),

                  CustomTextField(
                    label: 'Tagline *',
                    hint: 'A catchy one-liner that describes your startup',
                    controller: _taglineController,
                    validator: _validateTagline,
                    prefixIcon: const Icon(Icons.campaign),
                  ).animate().slideX(delay: 200.ms, begin: -0.3),

                  const SizedBox(height: AppConstants.largeSpacing),

                  CustomTextField(
                    label: 'Description *',
                    hint:
                        'Describe your startup idea, target market, and how it solves a problem...',
                    controller: _descriptionController,
                    validator: _validateDescription,
                    maxLines: 6,
                    keyboardType: TextInputType.multiline,
                    prefixIcon: const Icon(Icons.description),
                  ).animate().slideX(delay: 300.ms, begin: -0.3),

                  const SizedBox(height: AppConstants.extraLargeSpacing),

                  // Character Counters
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildCharacterCounter('Name', _nameController, 50),
                      _buildCharacterCounter(
                        'Tagline',
                        _taglineController,
                        100,
                      ),
                      _buildCharacterCounter(
                        'Description',
                        _descriptionController,
                        1000,
                      ),
                    ],
                  ).animate().fadeIn(delay: 400.ms),

                  const SizedBox(height: AppConstants.extraLargeSpacing),

                  // Submit Button
                  CustomButton(
                    text: 'Submit for AI Review',
                    onPressed: _submitIdea,
                    isLoading: _isSubmitting,
                    icon: const Icon(Icons.send, size: 20),
                    height: 56,
                  ).animate().slideY(delay: 500.ms, begin: 0.3),

                  const SizedBox(height: AppConstants.mediumSpacing),

                  // Clear Button
                  CustomButton(
                    text: 'Clear Form',
                    onPressed: _clearForm,
                    isOutlined: true,
                    icon: const Icon(Icons.clear_all, size: 20),
                  ).animate().slideY(delay: 600.ms, begin: 0.3),

                  const SizedBox(height: AppConstants.largeSpacing),

                  // Tips Section
                  Container(
                    padding: const EdgeInsets.all(AppConstants.mediumSpacing),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceVariant,
                      borderRadius: BorderRadius.circular(
                        AppConstants.mediumRadius,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.tips_and_updates,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: AppConstants.smallSpacing),
                            Text(
                              'Tips for a Great Submission',
                              style: AppTextStyles.subtitle1.copyWith(
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppConstants.mediumSpacing),
                        ..._buildTips().map(
                          (tip) => Padding(
                            padding: const EdgeInsets.only(
                              bottom: AppConstants.smallSpacing,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  size: 16,
                                  color: AppColors.success,
                                ),
                                const SizedBox(
                                  width: AppConstants.smallSpacing,
                                ),
                                Expanded(
                                  child: Text(
                                    tip,
                                    style: AppTextStyles.body2.copyWith(
                                      color:
                                          Theme.of(
                                            context,
                                          ).colorScheme.onSurface,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 700.ms).slideY(begin: 0.2),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCharacterCounter(
    String label,
    TextEditingController controller,
    int maxLength,
  ) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, value, child) {
        final count = value.text.length;
        final color =
            count > maxLength
                ? AppColors.error
                : count > maxLength * 0.8
                ? AppColors.warning
                : Theme.of(context).colorScheme.onSurface.withOpacity(0.6);

        return Column(
          children: [
            Text(
              '$count',
              style: AppTextStyles.caption.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(label, style: AppTextStyles.caption.copyWith(color: color)),
          ],
        );
      },
    );
  }

  List<String> _buildTips() {
    return [
      'Be specific about the problem you\'re solving',
      'Clearly describe your target audience',
      'Explain what makes your idea unique',
      'Use simple, clear language',
      'Include potential business model if possible',
    ];
  }

  void _showSuccessDialog(int rating) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.largeRadius),
            ),
            title: Row(
              children: [
                Icon(Icons.celebration, color: AppColors.success),
                const SizedBox(width: AppConstants.smallSpacing),
                Text('Success!'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Your idea has been submitted and analyzed by our AI!',
                  style: AppTextStyles.body1,
                ),
                const SizedBox(height: AppConstants.mediumSpacing),
                Container(
                  padding: const EdgeInsets.all(AppConstants.mediumSpacing),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(
                      AppConstants.mediumRadius,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text('AI Rating', style: AppTextStyles.caption),
                      Text(
                        '$rating/100',
                        style: AppTextStyles.heading2.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  AppNavigation.goToIdeas();
                },
                child: Text('View All Ideas'),
              ),
            ],
          ),
    );
  }
}
