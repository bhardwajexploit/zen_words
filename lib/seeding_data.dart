// import 'dart:convert';
// import 'package:http/http.dart' as http;
//
// import 'data/remote/supabase_service.dart';
//
// class ZenSeeder {
//   static Future<void> seedQuotes() async {
//     print("Fetching Zen quotes...");
//
//     final response = await http.get(
//       Uri.parse("https://zenquotes.io/api/quotes"),
//     );
//
//     final List data = jsonDecode(response.body);
//
//     print("Fetched ${data.length} quotes");
//
//     for (final item in data) {
//       await SupabaseService.client.from("quotes").insert({
//         "q": item["q"],
//         "a": item["a"],
//         'c':item['c'],
//       });
//     }
//
//     print("Seeding complete.");
//   }
// }
