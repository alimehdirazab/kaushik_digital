import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kaushik_digital/Services/account_services.dart';
import 'package:kaushik_digital/utils/constants/constants.dart';

class FaqsScreen extends StatelessWidget {
  const FaqsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AccountService accountService = AccountService();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: primaryColor,
          title: Text("FAQs",
              style: GoogleFonts.montserrat(
                textStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600),
              ))),
      body: FutureBuilder<Map<String, dynamic>>(
        future: accountService.getFAQs(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error}"),
            );
          } else if (snapshot.data!.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            final data = snapshot.data!["VIDEO_STREAMING_APP"];
            final String cleanedHtml =
                data["page_content"].replaceAll('\\"', '"');

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data["page_title"],
                    style: const TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Html(
                    data: cleanedHtml,
                    style: {
                      "p": Style(fontSize: FontSize.large),
                      "strong": Style(fontWeight: FontWeight.bold),
                      "ul": Style(padding: HtmlPaddings.only(left: 20)),
                      "li": Style(
                        margin: Margins.only(bottom: 10),
                      ),
                    },
                  ),
                ],
              ),
            );
          } else {
            return const Center(
              child: Text("No data available"),
            );
          }
        },
      ),
    );
  }
}
