// import 'package:careconnect_mobile/core/layouts/master_screen.dart';
// import 'package:careconnect_mobile/models/responses/employee.dart';
// import 'package:careconnect_mobile/models/responses/search_result.dart';
// import 'package:careconnect_mobile/providers/employee_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class EmployeeListScreen extends StatefulWidget {
//   const EmployeeListScreen({super.key});

//   @override
//   State<EmployeeListScreen> createState() => _EmployeeListScreenState();
// }

// class _EmployeeListScreenState extends State<EmployeeListScreen> {
//   late EmployeeProvider _employeeProvider;
//   SearchResult<Employee>? data = null;
//   TextEditingController _seachController = TextEditingController();

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();

//     _employeeProvider = context.read<EmployeeProvider>();
//     loadData();
//   }

//   Future loadData() async {
//     var tmpData = await _employeeProvider.get();
//     setState(() {
//       data = tmpData;
//     });
//   }

//   SearchResult<Employee>? result = null;
//   @override
//   Widget build(BuildContext context) {
//     return MasterScreen(
//       "Employees",
//       SingleChildScrollView(
//         child: Container(
//           child: Column(
//             children: [
//               _buildEmployeeSearch(),
//               // Container(
//               //   height: 500,
//               //   child: GridView(
//               //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//               //       crossAxisCount: 2,
//               //       childAspectRatio: 4 / 3,
//               //       crossAxisSpacing: 10,
//               //       mainAxisExtent: 30,
//               //     ),
//               //     scrollDirection: Axis.horizontal,
//               //     children: _buildEmployeeCardList(),
//               //   ),
//               // ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   List<Widget> _buildEmployeeCardList() {
//     if (data?.result.length == 0) {
//       return [Text("Loading...")];
//     }

//     List<Widget> list = data!.result
//         .map(
//           (e) => Container(
//             child: Column(
//               children: [Text(e.hireDate.toString()), Text(e.jobTitle ?? "")],
//             ),
//           ),
//         )
//         .cast<Widget>()
//         .toList();

//     return list;
//   }

//   Widget _buildEmployeeSearch() {
//     return Row(
//       children: [
//         Expanded(
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: TextField(
//               controller: _seachController,
//               onSubmitted: (value) async {
//                 var tmpData = await _employeeProvider.get(
//                   filter: {'fts': _seachController.text},
//                 );

//                 setState(() {
//                   data = tmpData;
//                 });
//               },
//               decoration: InputDecoration(
//                 hintText: "Search",
//                 prefixIcon: Icon(Icons.search),
//               ),
//             ),
//           ),
//         ),
//         Container(
//           padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
//           child: IconButton(
//             icon: Icon(Icons.filter_list),
//             onPressed: () async {
//               var tmpData = await _employeeProvider.get(
//                 filter: {'fts': _seachController.text},
//               );

//               setState(() {
//                 data = tmpData;
//               });
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }
