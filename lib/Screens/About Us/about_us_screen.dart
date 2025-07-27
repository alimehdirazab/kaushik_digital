import 'package:flutter/material.dart';
import 'package:kaushik_digital/Services/account_services.dart';
import 'package:kaushik_digital/utils/constants/constants.dart';

class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({super.key});

  @override
  State<AboutUsScreen> createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  bool isLoading = true;
  Map<String, dynamic> aboutUsData = {};

  @override
  void initState() {
    super.initState();
    fetchAboutUsData();
  }

  Future<void> fetchAboutUsData() async {
    try {
      final data = await AccountService().getAboutUs(context);
      setState(() {
        aboutUsData = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching About Us data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: const Color(0xffffffff),
      appBar: AppBar(
        //backgroundColor: const Color(0xff121212),
        title: const Text(
          'About Us',
          style: TextStyle(
           
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,),
          onPressed: () => Navigator.pop(context),
        ),
      
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (aboutUsData['VIDEO_STREAMING_APP'] != null)
                    _buildAboutUsContent(aboutUsData['VIDEO_STREAMING_APP'])
                  else
                    Center(
                      child: Text(
                        'No About Us information available',
                        style: TextStyle(
                          color: whiteColor,
                          fontSize: 16,
                        ),
                      ),
                    ),
                ],
              ),
            ),
    );
  }

  Widget _buildAboutUsContent(Map<String, dynamic> content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (content['page_content'] != null)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'About Kaushik Digital',
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                _parseHtmlContent(content['page_content']),
                style: const TextStyle(  
                  fontSize: 16,
                  height: 1.6,
                ),
                textAlign: TextAlign.justify,
              ),
            ],
          ),
        const SizedBox(height: 24),
        
        // // App Features Section
        // Container(
        //   width: double.infinity,
        //   padding: const EdgeInsets.all(16.0),
        //   decoration: BoxDecoration(
        //     color: const Color(0xff1E1E1E),
        //     borderRadius: BorderRadius.circular(12),
        //     border: Border.all(
        //       color: primaryColor.withOpacity(0.3),
        //       width: 1,
        //     ),
        //   ),
        //   child: Column(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [
        //       Text(
        //         'Key Features',
        //         style: TextStyle(
        //           color: primaryColor,
        //           fontSize: 20,
        //           fontWeight: FontWeight.bold,
        //         ),
        //       ),
        //       const SizedBox(height: 16),
        //       _buildFeatureItem(Icons.movie, 'Extensive Content Library'),
        //       _buildFeatureItem(Icons.hd, 'HD Quality Streaming'),
        //       _buildFeatureItem(Icons.download, 'Offline Download'),
        //       _buildFeatureItem(Icons.devices, 'Multi-Device Support'),
        //       _buildFeatureItem(Icons.account_circle, 'User Profiles'),
        //     ],
        //   ),
        // ),
      ],
    );
  }

  // Widget _buildFeatureItem(IconData icon, String text) {
  //   return Padding(
  //     padding: const EdgeInsets.only(bottom: 12.0),
  //     child: Row(
  //       children: [
  //         Icon(
  //           icon,
  //           color: primaryColor,
  //           size: 24,
  //         ),
  //         const SizedBox(width: 12),
  //         Expanded(
  //           child: Text(
  //             text,
  //             style: TextStyle(
  //               color: whiteColor,
  //               fontSize: 16,
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  String _parseHtmlContent(String htmlContent) {
    // Basic HTML tag removal for display
    String cleanContent = htmlContent
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&rsquo;', "'")
        .replaceAll('&lsquo;', "'")
        .replaceAll('&ldquo;', '"')
        .replaceAll('&rdquo;', '"')
        .replaceAll('&mdash;', '—')
        .replaceAll('&amp;', '&');
    
    return cleanContent.trim();
  }
}
