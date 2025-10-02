import 'package:careconnect_mobile/models/auth_user.dart';
import 'package:careconnect_mobile/models/enums/workshop_status.dart';
import 'package:careconnect_mobile/models/responses/child.dart';
import 'package:careconnect_mobile/models/responses/workshop.dart';
import 'package:careconnect_mobile/providers/auth_provider.dart';
import 'package:careconnect_mobile/providers/participant_provider.dart';
import 'package:careconnect_mobile/providers/workshop_provider.dart';
import 'package:careconnect_mobile/screens/workshop_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MyWorkshopsScreen extends StatefulWidget {
  const MyWorkshopsScreen({super.key});

  @override
  State<MyWorkshopsScreen> createState() => _MyWorkshopsScreenState();
}

class _MyWorkshopsScreenState extends State<MyWorkshopsScreen> {
  bool isLoading = false;

  late WorkshopProvider workshopProvider;
  late ParticipantProvider participantProvider;

  List<Workshop> workshops = [];

  AuthUser? currentUser;

  final TextEditingController _searchController = TextEditingController();

  String? workshopName;
  String? selectedWorkshopType;

  @override
  void initState() {
    super.initState();

    workshopProvider = context.read<WorkshopProvider>();
    participantProvider = context.read<ParticipantProvider>();

    final auth = Provider.of<AuthProvider>(context, listen: false);

    setState(() {
      currentUser = auth.user;
    });

    loadWorkshops();
  }

  Future<void> loadWorkshops() async {
    setState(() {
      isLoading = true;
    });

    final response = await workshopProvider.loadData(
      participantId: currentUser!.id,
      nameGTE: workshopName,
    );

    setState(() {
      workshops = response?.result ?? [];
      isLoading = false;
    });
  }

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
          'Workshops',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: colorScheme.onSurface,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                // Search bar
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: "Search by workshop name...",
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      isDense: true,
                    ),
                    onChanged: (value) {
                      setState(() {
                        workshopName = value;
                      });
                      loadWorkshops();
                    },
                  ),
                ),
                const SizedBox(width: 8),
              ],
            ),
          ),
          Expanded(child: _buildMyWorkshops(colorScheme)),
        ],
      ),
      //),
    );
  }

  Widget _buildMyWorkshops(ColorScheme colorScheme) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (workshops.isEmpty) {
      return const Center(
        child: Text(
          "No workshops found.",
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(8),
      itemCount: workshops.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final workshop = workshops[index];
        return _buildWorkshopCard(workshop, colorScheme);
      },
    );
  }

  Widget _buildWorkshopCard(Workshop workshop, ColorScheme colorScheme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Main column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  workshop.name,
                  style: TextStyle(color: colorScheme.primary, fontSize: 16),
                ),
                const SizedBox(height: 8),

                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                  decoration: BoxDecoration(
                    color: workshop.workshopType == "Parents"
                        ? Color(0xFFFFE0D6)
                        : Color(0xFFD0E8FF),
                    border: null,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    workshop.workshopType == "Parents" ? "Parents" : "Children",
                    style: TextStyle(
                      color: workshop.workshopType == "Parents"
                          ? Color.fromARGB(255, 80, 80, 80)
                          : Color.fromARGB(255, 80, 80, 80),
                    ),
                  ),
                ),

                if (workshop.workshopType == "Children")
                  FutureBuilder<List<Child>>(
                    future: _getEnrolledChildren(workshop),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Text("No children enrolled yet.");
                      }

                      final children = snapshot.data!;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Enrolled children:",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          ...children
                              .map((child) => Text("- ${child.firstName}"))
                              .toList(),
                        ],
                      );
                    },
                  ),

                const SizedBox(height: 8),

                _buildWorkshopDetail(
                  Icons.date_range,
                  workshop.endDate != null
                      ? '${DateFormat('d. MM. yyyy').format(workshop.startDate)} - ${DateFormat('d. MM. yyyy').format(workshop.endDate!)}'
                      : DateFormat('d MMM y').format(workshop.startDate),
                ),

                const SizedBox(height: 8),

                Wrap(
                  spacing: 16,
                  runSpacing: 8,
                  children: [
                    _buildWorkshopDetail(
                      Icons.attach_money,
                      workshop.price != null ? "\$${workshop.price}" : "Free",
                    ),
                    _buildWorkshopDetail(
                      Icons.group,
                      "${workshop.participants ?? 0}/${workshop.maxParticipants ?? 0}",
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            height: 130,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //scrossAxisAlignment: CrossAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            WorkshopDetailsScreen(workshop: workshop),
                      ),
                    );
                  },
                  icon: const Icon(Icons.chevron_right, color: Colors.grey),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 1,
                  ),
                  decoration: BoxDecoration(
                    color: workshopStatusFromString(
                      workshop.status,
                    ).backgroundColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    workshopStatusFromString(workshop.status).label,
                    style: TextStyle(
                      color: workshopStatusFromString(
                        workshop.status,
                      ).textColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<List<Child>> _getEnrolledChildren(Workshop workshop) async {
    if (currentUser == null) return [];

    final response = await participantProvider.loadData(
      workshopId: workshop.workshopId,
    );

    if (response == null) return [];

    final filtered = response.result.where((a) {
      return a.user!.userId == currentUser!.id;
    }).toList();

    final children = filtered
        .map((a) => a.child)
        .where((e) => e != null)
        .cast<Child>()
        .toSet()
        .toList();

    return children;
  }

  Widget _buildWorkshopDetail(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 14)),
      ],
    );
  }

  WorkshopStatus getStatus(String status) {
    return workshopStatusFromString(status);
  }
}
