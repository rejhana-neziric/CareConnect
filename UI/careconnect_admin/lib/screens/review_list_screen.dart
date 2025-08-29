import 'package:careconnect_admin/core/layouts/master_screen.dart';
import 'package:careconnect_admin/models/responses/review.dart';
import 'package:careconnect_admin/models/responses/search_result.dart';
import 'package:careconnect_admin/providers/review_provider.dart';
import 'package:careconnect_admin/core/theme/app_colors.dart';
import 'package:careconnect_admin/widgets/confirm_dialog.dart';
import 'package:careconnect_admin/widgets/custom_dropdown_fliter.dart';
import 'package:careconnect_admin/widgets/no_results.dart';
import 'package:careconnect_admin/widgets/primary_button.dart';
import 'package:careconnect_admin/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:staggered_grid_view/flutter_staggered_grid_view.dart';

class ReviewListScreen extends StatefulWidget {
  const ReviewListScreen({super.key});

  @override
  State<ReviewListScreen> createState() => _ReviewListScreenState();
}

class _ReviewListScreenState extends State<ReviewListScreen> {
  late ReviewProvider reviewProvider;

  SearchResult<Review>? reviews;
  int currentPage = 0;

  final _ftsController = TextEditingController();

  String? _sortBy;
  bool _sortAscending = true;

  String? selectedSortingOption;

  final Map<String, String?> sortingOptions = {
    'Not sorted': null,
    'Employee': 'employee',
    'User': 'user',
    'Rating': 'rating',
    'Publish Date': 'date',
  };

  bool? isHidden;

  String? selectedVisibilityOption;

  final Map<String, String?> visibilityOptions = {
    'All': null,
    'Visible': 'false',
    'Hidden': 'true',
  };

  double averageRating = 0.0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    reviewProvider = context.read<ReviewProvider>();
    loadData();
  }

  Future<SearchResult<Review>?> loadData() async {
    final reviewProvider = Provider.of<ReviewProvider>(context, listen: false);

    final result = await reviewProvider.loadData(
      fts: _ftsController.text,
      isHidden: isHidden,
      publishDateGTE: null,
      publishDateLTE: null,
      stars: null,
      sortBy: _sortBy,
      sortAscending: _sortAscending,
    );

    reviews = result;

    averageRating = await reviewProvider.getAverage();

    if (mounted) {
      setState(() {});
    }

    return reviews;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return MasterScreen(
      "Reviews",
      SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            _buildSearch(colorScheme),
            _buildAverageRating(averageRating),
            Consumer<ReviewProvider>(
              builder: (context, reviewProvider, child) {
                return _buildResultView();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAverageRating(double avgRating) {
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RatingBarIndicator(
            rating: averageRating,
            itemBuilder: (context, index) =>
                const Icon(Icons.star, color: Colors.amber),
            itemCount: 5,
            itemSize: 32.0,
            unratedColor: Colors.grey.shade300,
            direction: Axis.horizontal,
          ),
          SizedBox(width: 4),
          Text(averageRating.toString(), style: TextStyle(fontSize: 18)),
          SizedBox(width: 4),
          Text("(${reviews?.totalCount.toString() ?? ""} reviews)"),
        ],
      ),
    );
  }

  Widget _buildSearch(ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerLowest,
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Search field
              SizedBox(
                width: 500,
                child: TextField(
                  controller: _ftsController,
                  decoration: InputDecoration(
                    labelText:
                        "Search Employee's and User's First Name and Last Name",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.search),
                    filled: true,
                    fillColor: colorScheme.surfaceContainerLowest,
                  ),
                  onChanged: (value) => loadData(),
                ),
              ),
              const SizedBox(width: 8),
              // Visibility Dropdown
              SizedBox(
                width: 180,
                child: CustomDropdownFliter(
                  selectedValue: selectedVisibilityOption,
                  options: visibilityOptions,
                  name: "Visibility: ",
                  onChanged: (newStatus) {
                    setState(() {
                      selectedVisibilityOption = newStatus;
                      isHidden = newStatus == 'true'
                          ? true
                          : newStatus == 'false'
                          ? false
                          : null;
                    });
                    loadData();
                  },
                ),
              ),
              const SizedBox(width: 8),
              //Sort By Dropdown
              SizedBox(
                width: 220,
                child: CustomDropdownFliter(
                  selectedValue: selectedSortingOption,
                  options: sortingOptions,
                  name: "Sort by: ",
                  onChanged: (newStatus) {
                    setState(() {
                      selectedSortingOption = newStatus;
                      _sortBy = newStatus;
                    });
                    loadData();
                  },
                ),
              ),
              const SizedBox(width: 8),
              // Asc/Desc Toggle
              IconButton(
                icon: Icon(
                  _sortAscending ? Icons.arrow_upward : Icons.arrow_downward,
                  color: colorScheme.onPrimaryContainer,
                ),
                tooltip: _sortAscending ? 'Ascending' : 'Descending',
                onPressed: () {
                  setState(() => _sortAscending = !_sortAscending);
                  loadData();
                },
              ),
              const SizedBox(width: 8),
              // Refresh Button
              TextButton.icon(
                onPressed: () {
                  _ftsController.clear();
                  _sortBy = null;
                  isHidden = null;
                  selectedVisibilityOption = null;
                  selectedSortingOption = null;
                  loadData();
                },
                label: Text(
                  "Refresh",
                  style: TextStyle(color: colorScheme.onPrimaryContainer),
                ),
                icon: Icon(
                  Icons.refresh_outlined,
                  color: colorScheme.onPrimaryContainer,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultView() {
    return (reviews != null && reviews?.result.isEmpty == false)
        ? Center(
            child: StaggeredGridView.countBuilder(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(
                horizontal: 180.0,
                vertical: 64.0,
              ),
              crossAxisSpacing: 32,
              mainAxisSpacing: 16,
              itemCount: reviews!.result.length,
              itemBuilder: (context, index) {
                return buildReviews(reviews!.result)[index];
              },
              staggeredTileBuilder: (index) => StaggeredTile.fit(1),
            ),
          )
        : Padding(
            padding: const EdgeInsets.all(128.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                NoResultsWidget(
                  message: 'No results found. Please try again.',
                  icon: Icons.sentiment_dissatisfied,
                ),
              ],
            ),
          );
  }

  List<Widget> buildReviews(List<Review> review) {
    return review.map((item) => _buildReview(item)).toList();
  }

  Widget _buildReview(Review review) {
    return ReviewCard(review: review, loadData: loadData);
  }
}

class ReviewCard extends StatefulWidget {
  final Review review;
  final Future<SearchResult<Review>?> Function() loadData;

  const ReviewCard({super.key, required this.review, required this.loadData});

  @override
  State<ReviewCard> createState() => _ReviewCardState();
}

class _ReviewCardState extends State<ReviewCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SizedBox(
      width: 500,
      // for 3 cards width 350
      child: Card(
        color: colorScheme.surfaceContainerLowest,
        margin: EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isHovered ? AppColors.mauveGray : Colors.transparent,
            width: 1,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.review.isHidden)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 0,
                    vertical: 4,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade400),
                        ),
                        child: Text(
                          "Hidden",
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      widget.review.title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.mauveGray,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  Row(
                    children: [
                      Text(
                        "${widget.review.stars}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.star, color: Colors.amber, size: 18),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    "Employee: ${widget.review.employee?.user?.firstName} ${widget.review.employee?.user?.lastName}",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(widget.review.content),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Written by: ${widget.review.user.firstName} ${widget.review.user.lastName}",
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Edited: ${DateFormat('d. M. y.').format(widget.review.modifiedDate)}",
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  PrimaryButton(
                    onPressed: () async {
                      final shouldProceed = await CustomConfirmDialog.show(
                        context,
                        icon: Icons.info,
                        title: widget.review.isHidden
                            ? 'Unhide Review'
                            : 'Hide Review',
                        content: widget.review.isHidden
                            ? 'Are you sure you want to unhide this review?'
                            : 'Are you sure you want to hide this review?',
                        confirmText: widget.review.isHidden ? 'Unhide' : 'Hide',
                        cancelText: 'Cancel',
                      );

                      if (shouldProceed != true) return;

                      final result = await Provider.of<ReviewProvider>(
                        context,
                        listen: false,
                      ).changeVisibility(widget.review.reviewId);

                      CustomSnackbar.show(
                        context,
                        message: result
                            ? 'Review visibility successfully changed.'
                            : 'Something went wrong. Please try again.',
                        type: result
                            ? SnackbarType.success
                            : SnackbarType.error,
                      );

                      if (result == true) widget.loadData();
                    },
                    label: widget.review.isHidden ? 'Unhide' : ' Hide',
                    backgroundColor: Colors.grey.shade300,
                    textColor: Colors.black87,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
