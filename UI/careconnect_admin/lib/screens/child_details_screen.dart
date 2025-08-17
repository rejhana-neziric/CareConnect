import 'package:careconnect_admin/layouts/master_screen.dart';
import 'package:careconnect_admin/models/responses/appointment.dart';
import 'package:careconnect_admin/models/responses/child.dart';
import 'package:careconnect_admin/models/responses/children_diagnosis.dart';
import 'package:careconnect_admin/models/responses/client.dart';
import 'package:careconnect_admin/models/responses/clients_child.dart';
import 'package:careconnect_admin/models/responses/search_result.dart';
import 'package:careconnect_admin/models/search_objects/children_diagnosis_additional_data.dart';
import 'package:careconnect_admin/models/search_objects/children_diagnosis_search_object.dart';
import 'package:careconnect_admin/providers/children_diagnosis_provider.dart';
import 'package:careconnect_admin/providers/clients_child_form_provider.dart';
import 'package:careconnect_admin/providers/clients_child_provider.dart';
import 'package:careconnect_admin/theme/app_colors.dart';
import 'package:careconnect_admin/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:timeline_tile/timeline_tile.dart';

class ChildDetailsScreen extends StatefulWidget {
  final Client client;
  final Child child;

  const ChildDetailsScreen({
    super.key,
    required this.client,
    required this.child,
  });

  @override
  State<ChildDetailsScreen> createState() => _ChildDetailsScreenState();
}

class _ChildDetailsScreenState extends State<ChildDetailsScreen> {
  // Map<String, dynamic> _initialValue = {};
  SearchResult<ClientsChild>? result;
  late ClientsChildProvider clientsChildProvider;
  late ClientsChildFormProvider clientsChildFormProvider;
  late ChildrenDiagnosisProvider childrenDiagnosisProvider;
  bool isLoading = true;
  ClientsChild? clientsChild;

  SearchResult<ChildrenDiagnosis>? childrenDiagnosis;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();

    clientsChildProvider = context.read<ClientsChildProvider>();
    clientsChildFormProvider = context.read<ClientsChildFormProvider>();
    childrenDiagnosisProvider = context.read<ChildrenDiagnosisProvider>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      initForm();
    });

    loadDiagnosis();

    if (clientsChildProvider.shouldRefresh) {
      loadDiagnosis();
      clientsChildProvider.markRefreshed();
    }
  }

  void initForm() {
    setState(() {
      isLoading = false;
    });
  }

  Future<SearchResult<ChildrenDiagnosis>> loadDiagnosis() async {
    final filterObject = ChildrenDiagnosisSearchObject(
      childFirstNameGTE: widget.child.firstName,
      additionalData: ChildrenDiagnosisAdditionalData(
        isDiagnosisIncluded: true,
        isChildIncluded: true,
      ),
    );

    final filter = filterObject.toJson();

    final result = await childrenDiagnosisProvider.get(filter: filter);

    childrenDiagnosis = result;

    if (mounted) {
      setState(() {});
    }

    return result;
  }

  Future<ClientsChild?> loadData() async {
    final result = await clientsChildProvider.getClientAndChildById(
      clientId: widget.client.user?.userId,
      childId: widget.child.childId,
    );

    clientsChild = result;

    if (mounted) {
      setState(() {});
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      "Child Details",
      SingleChildScrollView(
        padding: const EdgeInsets.all(64),
        scrollDirection: Axis.vertical,
        child: SizedBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,

                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      basicInfoCard(),
                      SizedBox(height: 16),
                      buildDiganosis(),
                    ],
                  ),
                  SizedBox(width: 16),
                  Expanded(child: appointmentSchedule()),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget basicInfoCard() {
    return SizedBox(
      width: 800,
      height: 200,
      child: Card(
        margin: EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Child Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.mauveGray,
                ),
              ),
              SizedBox(height: 12),
              infoRow(
                'Name',
                "${widget.child.firstName} ${widget.child.lastName}",
              ),
              SizedBox(height: 6),

              infoRow('Gender', widget.child.gender == "M" ? "Male" : "Female"),
              SizedBox(height: 6),

              infoRow(
                'Birthday',
                DateFormat(
                  'd. M. y.',
                ).format(widget.child.birthDate).toString(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget infoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              color: AppColors.mauveGray,
            ),
          ),
          Expanded(child: Text(value, overflow: TextOverflow.ellipsis)),
        ],
      ),
    );
  }

  Widget appointmentSchedule() {
    final appointments = clientsChild?.appointments;

    return SizedBox(
      width: 400,
      height: 500,
      child: Card(
        margin: EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Appointment Schedule',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.mauveGray,
                  ),
                ),
                SizedBox(height: 12),
                ...((appointments != null && appointments.isNotEmpty)
                    ? buildAppointments(appointments)
                    : [const Text("No appointments scheduled.")]),
                SizedBox(height: 340),
                Align(
                  alignment: Alignment.centerRight,
                  child: PrimaryButton(
                    onPressed: () => {},
                    label: "Add new appointment",
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> buildAppointments(List<Appointment> appointments) {
    return appointments.map((item) => buildTimelineTile(item)).toList();
  }

  Widget buildTimelineTile(Appointment item) {
    return TimelineTile(
      alignment: TimelineAlign.start,
      indicatorStyle: IndicatorStyle(
        color: const Color.fromARGB(255, 155, 111, 137),
        padding: EdgeInsets.symmetric(vertical: 8),
      ),
      beforeLineStyle: LineStyle(color: Colors.grey.shade300, thickness: 2),
      endChild: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item.date.toString(), style: TextStyle(color: Colors.grey)),
            SizedBox(height: 4),
            Text(
              item.appointmentType,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            Text("nesto", style: TextStyle(color: Colors.grey.shade600)),
          ],
        ),
      ),
    );
  }

  Widget buildDiganosis() {
    return SizedBox(
      width: 800,
      height: 300,
      child: Card(
        margin: EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    'Diagnosis',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.mauveGray,
                    ),
                  ),
                ),

                (childrenDiagnosis != null &&
                        childrenDiagnosis!.result.isNotEmpty)
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: childrenDiagnosis!.result
                            .map(buildDiagnosisItem)
                            .toList(),
                      )
                    : const Text("No diagnoses found."),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDiagnosisItem(ChildrenDiagnosis childrenDiagnosis) {
    return ExpansionTile(
      title: Text(childrenDiagnosis.diagnosis.name),
      subtitle: Text(
        childrenDiagnosis.diagnosisDate != null
            ? "Diagnosis date: ${DateFormat.yMMMd().format(childrenDiagnosis.diagnosisDate!)}"
            : "Diagnosis date: Not recorded.",
      ),
      children: [
        //if (childrenDiagnosis.diagnosis.description != null)
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: childrenDiagnosis.diagnosis.description != null
              ? Text(childrenDiagnosis.diagnosis.description!)
              : Text("No description."),
        ),
        if (childrenDiagnosis.notes != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Notes: ${childrenDiagnosis.notes}"),
          ),
      ],
    );
  }
}
