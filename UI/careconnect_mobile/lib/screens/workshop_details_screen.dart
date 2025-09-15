import 'package:careconnect_mobile/models/responses/workshop.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WorkshopDetailsScreen extends StatefulWidget {
  final Workshop workshop;
  const WorkshopDetailsScreen({super.key, required this.workshop});

  @override
  State<WorkshopDetailsScreen> createState() => _WorkshopDetailsScreenState();
}

class _WorkshopDetailsScreenState extends State<WorkshopDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerLow,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: colorScheme.surfaceContainerLow,
        foregroundColor: colorScheme.onSurface,
        title: Text(
          'Workshops Details',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: colorScheme.onSurface,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWorkshopInfo(colorScheme),
            _buildDateTimeCard(colorScheme),
            const SizedBox(height: 16),
          ],
        ),
      ),

      bottomNavigationBar: _buildBottomBar(colorScheme),
    );
  }

  Widget _buildWorkshopInfo(ColorScheme colorScheme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.workshop.name,
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '- Workshop for ${widget.workshop.workshopType}',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          _buildWorkshopSpots(colorScheme),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildPriceCard(
                'Regular price',
                widget.workshop.price,
                Icons.attach_money,
                colorScheme,
              ),
              const SizedBox(width: 12),
              if (widget.workshop.memberPrice != null)
                _buildPriceCard(
                  'Member price',
                  widget.workshop.memberPrice,
                  Icons.card_membership,
                  colorScheme,
                ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'Description',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.workshop.description,
            style: TextStyle(
              fontSize: 16,
              color: colorScheme.onSurface,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceCard(
    String label,
    double? price,
    IconData icon,
    ColorScheme colorScheme,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colorScheme.surfaceContainerLowest),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: colorScheme.primary, size: 20),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  price != null ? '\$${price.toStringAsFixed(2)}' : 'N/A',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateTimeCard(ColorScheme colorScheme) {
    final startDate = widget.workshop.startDate;
    final endDate = widget.workshop.endDate;

    return Container(
      padding: const EdgeInsets.all(24),
      margin: EdgeInsets.symmetric(horizontal: 24),

      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildDateInfo(colorScheme, 'Start date', startDate),
          if (endDate != null) ...[
            const Divider(height: 32),
            _buildDateInfo(colorScheme, 'End date', endDate),
          ],
        ],
      ),
    );
  }

  Widget _buildDateInfo(ColorScheme colorScheme, String title, DateTime date) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.only(left: 20),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
          child: Icon(
            Icons.calendar_month,
            color: colorScheme.primary,
            size: 25,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                DateFormat('EEEE, d. MM. yyyy.').format(date),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWorkshopSpots(ColorScheme colorScheme) {
    if ((widget.workshop.maxParticipants == null &&
            widget.workshop.participants == null) ||
        widget.workshop.participants == null) {
      return SizedBox.shrink();
    }

    final available =
        widget.workshop.maxParticipants! - widget.workshop.participants!;
    final progress =
        (widget.workshop.participants! / widget.workshop.maxParticipants!)
            .clamp(0.0, 1.0);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Available spots: $available / ${widget.workshop.maxParticipants}",
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 12,
                backgroundColor: colorScheme.surfaceVariant,
                valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(ColorScheme colorScheme) {
    if (widget.workshop.maxParticipants == null ||
        (widget.workshop.participants != null &&
            widget.workshop.participants! >=
                widget.workshop.maxParticipants!)) {
      return SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: colorScheme.surfaceContainerLowest),
      child: SafeArea(
        child: ElevatedButton(
          onPressed: _enroll,
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.primaryContainer,
            foregroundColor: colorScheme.onSurface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
            elevation: 0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.calendar_today, size: 20),
              const SizedBox(width: 8),
              Text(
                'Enroll now',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _enroll() {
    //todo
  }
}
