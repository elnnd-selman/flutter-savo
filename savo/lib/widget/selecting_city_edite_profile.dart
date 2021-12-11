// import 'package:flutter/material.dart';
// import 'package:main/color.dart';
// import 'package:main/screens/edite_my_profile.dart';
// import 'package:searchable_dropdown/searchable_dropdown.dart';

// // This class uses searchable dropdown package
// // Link to it :  https://pub.dev/packages/searchable_dropdown

// class SelectingCity extends StatefulWidget {
//   final initialCity;
//   final String? type;
//   final Function? selectCategoryFun;
//   static const routeName = '/DropdownSearchable';

//   const SelectingCity(
//       {Key? key,
//       @required this.selectCategoryFun,
//       @required this.type,
//       this.initialCity})
//       : super(key: key);
//   @override
//   _DropdownSearchableState createState() => _DropdownSearchableState();
// }

// class _DropdownSearchableState extends State<SelectingCity> {
//   String? selectedValue;
//   List<int>? selectedItemss;
//   final List<DropdownMenuItem> items = [
//     DropdownMenuItem(
//       child: Text("Erbil"),
//       value: "Erbil",
//     ),
//     DropdownMenuItem(
//       child: Text("Sulaimany"),
//       value: "Sulaimany",
//     ),
//     DropdownMenuItem(
//       child: Text("Duhok"),
//       value: "Duhok",
//     ),
//     DropdownMenuItem(
//       child: Text("Halabja"),
//       value: "Halabja",
//     ),
//     DropdownMenuItem(
//       child: Text("Kirkuk"),
//       value: "Kirkuk",
//     ),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       constraints: BoxConstraints(maxWidth: 250),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: <Widget>[
//           Text('Choose City',
//               style: TextStyle(fontSize: 14, color: Colors.black)),
//           SearchableDropdown.single(
//             isExpanded: true,
//             items: items,
//             value: selectedValue,
//             hint: "Select one",
//             searchHint: "Select one",
//             style: TextStyle(color: tarik),
//             clearIcon: Icon(Icons.clear),
//             selectedValueWidgetFn: (value) {
//               return (Text(
//                 '',
//                 style: TextStyle(color: tarik),
//               ));
//             },
//             validator: (value) {
//               return null;
//             },
//             label: Column(children: [
//               RichText(
//                 text: TextSpan(
//                   style: TextStyle(
//                     color: tarik,
//                     fontSize: 14,
//                     fontFamily: 'rudaw',
//                   ),
//                   children: [
//                     TextSpan(text: 'Iraq / '),
//                     TextSpan(
//                       text: selectedValue != null
//                           ? selectedValue
//                           : widget.initialCity != null
//                               ? widget.initialCity.toString().split('/')[1]
//                               : 'select ity',
//                       style: TextStyle(
//                         color: tarik,
//                         fontSize: 14,
//                         fontFamily: 'Ar',
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//             ]),
//             displayItem: (item, selected) {
//               return (Row(
//                 children: [
//                   selected
//                       ? Icon(Icons.radio_button_checked)
//                       : Icon(Icons.radio_button_unchecked),
//                   Expanded(child: item)
//                 ],
//               ));
//             },
//             onChanged: (value) {
//               setState(() {
//                 selectedValue = value;
//                 widget.selectCategoryFun!(value);
//               });
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
