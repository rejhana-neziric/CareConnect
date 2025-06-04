import 'package:careconnect_admin/layouts/master_screen.dart';
import 'package:careconnect_admin/models/employee.dart';
import 'package:careconnect_admin/models/search_result.dart';
import 'package:careconnect_admin/providers/employee_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EmployeeListScreen extends StatefulWidget {
  const EmployeeListScreen({super.key});

  @override
  State<EmployeeListScreen> createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends State<EmployeeListScreen> {
  late EmployeeProvider provider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    provider = context.read<EmployeeProvider>();
  }

  SearchResult<Employee>? result = null;
  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      "Employees",
      Container(child: Column(children: [_buildSearch(), _buildResultView()])),
    );
  }

  TextEditingController _jobTitleEditingController =
      new TextEditingController();

  Widget _buildSearch() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(labelText: "First name"),
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _jobTitleEditingController,
              decoration: InputDecoration(labelText: "Job Title"),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              var filter = {'JobTitle': _jobTitleEditingController.text};
              result = await provider.get(filter: filter);
              setState(() {});
            },
            child: Text("Search"),
          ),
          SizedBox(width: 8),
          ElevatedButton(onPressed: () async {}, child: Text("Add")),
        ],
      ),
    );
  }

  Widget _buildResultView() {
    return Expanded(
      child: SingleChildScrollView(
        child: DataTable(
          columns: [
            DataColumn(label: Text("Hire date"), numeric: true),
            DataColumn(label: Text("data")),
          ],
          rows:
              result?.result
                  .map(
                    (e) => DataRow(
                      cells: [
                        DataCell(Text(e.hireDate.toString())),
                        DataCell(Text(e.jobTitle ?? "")),
                      ],
                    ),
                  )
                  .toList()
                  .cast<DataRow>() ??
              [],
        ),
      ),
    );
  }
}
