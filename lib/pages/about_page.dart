import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  Future<void> _launchURL() async {
    final Uri url = Uri.parse(
        'https://yangiasr.uz/files/books/2024-02-08-06-57-53_a861ad5d30911ff261dcee16f5d67332.pdf');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      body: CustomScrollView(
        slivers: [
          // Elegant Header with Visible Logo
          SliverAppBar(
            expandedHeight: 220.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text("Ilova Qo'llanmasi",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18)),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF0D47A1), Color(0xFF1976D2)],
                  ),
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 40),
                    child: SvgPicture.asset(
                      'lib/assets/PDP University.svg',
                      width: 180, // Clearly visible logo
                    ),
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Author Badge Card with Author Photo
                  _buildAuthorCard(),
                  const SizedBox(height: 24),

                  _buildSectionHeader("Ilova qanday ishlaydi?", Icons.auto_awesome),
                  const SizedBox(height: 12),

                  // Feature Cards
                  _buildFeatureStep(
                    "1",
                    "Savol va Eslatmalar",
                    "Har bir testning yuqori qismida mavzuga oid 'Note' mavjud. Bu sizga javob topishdan oldin mavzuni takrorlab olish imkonini beradi.",
                    Icons.menu_book_outlined,
                    Colors.amber,
                  ),
                  _buildFeatureStep(
                    "2",
                    "Interaktiv Tanlov",
                    "Variantni bosganingizda, tizim javobni bir zumda tekshiradi: To'g'ri (Yashil) yoki Xato (Qizil).",
                    Icons.touch_app_outlined,
                    Colors.blue,
                  ),
                  _buildFeatureStep(
                    "3",
                    "Aqlli O'tish (1.8s Delay)",
                    "Javobni tahlil qilib olishingiz uchun tizim 1.8 soniya kutadi va keyin avtomatik keyingi savolga o'tadi.",
                    Icons.timer_outlined,
                    Colors.deepOrange,
                  ),
                  _buildFeatureStep(
                    "4",
                    "Natijalar Arxivi",
                    "Barcha natijalaringiz xotiraga saqlanadi. 'Natijalar' bo'limida o'z o'sish dinamikangizni kuzatib boring.",
                    Icons.insights,
                    Colors.green,
                  ),

                  const SizedBox(height: 24),
                  _buildSectionHeader(
                      "Ilova haqida ma'lumot", Icons.info_outline),
                  const SizedBox(height: 12),

                  _buildInfoTile("Maqsad",
                      "O'zbekistonning eng yangi tarixi fanidan yakuniy imtihonlarga (Final Exam) tayyorgarlik ko'rish.",
                      Icons.track_changes),
                  _buildInfoTile("Versiya", "1.0.0 (Professional Edition)",
                      Icons.verified_user_outlined),

                  const SizedBox(height: 24),
                  _buildSectionHeader("Manba", Icons.library_books),
                  const SizedBox(height: 12),
                  _buildSourceCard(),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSourceCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 15,
              offset: const Offset(0, 5)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "O'zbekistonning eng yangi tarixi (o'quv qo'llanma). Toshkent 2021",
            style: TextStyle(
                fontSize: 15, color: Colors.black87, height: 1.5),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _launchURL,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0D47A1),
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text(
              "O'ZBEKISTONNING ENG YANGI TARIXI",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAuthorCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 15,
              offset: const Offset(0, 5)),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Author Photo from Assets
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.blue.shade100, width: 2),
                  image: const DecorationImage(
                    image: AssetImage('lib/assets/profile.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("G'oya va ilova muallifi:",
                        style: TextStyle(color: Colors.grey, fontSize: 14)),
                    SizedBox(height: 4),
                    Text("Amonov Dilmurod",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0D47A1))),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 40, thickness: 1),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildBadge("PDP University", Icons.school),
              _buildBadge("408-Gruh", Icons.groups),
              _buildBadge("2-Kurs", Icons.auto_graph),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(String text, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.blue.shade50.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: const Color(0xFF0D47A1)),
          const SizedBox(width: 6),
          Text(text,
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0D47A1))),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF0D47A1), size: 26),
        const SizedBox(width: 10),
        Text(title,
            style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3142))),
      ],
    );
  }

  Widget _buildFeatureStep(
      String step, String title, String desc, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.15), width: 2),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15)),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(height: 6),
                Text(desc,
                    style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 15,
                        height: 1.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile(String label, String value, IconData icon) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 6),
      color: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: Colors.grey.shade100)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: const Color(0xFF0D47A1)),
        ),
        title: Text(label,
            style: const TextStyle(
                fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w500)),
        subtitle: Text(value,
            style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3142))),
      ),
    );
  }
}
