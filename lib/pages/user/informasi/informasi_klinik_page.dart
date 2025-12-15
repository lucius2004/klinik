// lib/pages/user/informasi/informasi_klinik_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/layanan_provider.dart';

class InformasiKlinikPage extends StatelessWidget {
  const InformasiKlinikPage({super.key});

  @override
  Widget build(BuildContext context) {
    final layananProvider = Provider.of<LayananProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('INFORMASI KLINIK'),
        backgroundColor: const Color(0xFF2E7D32),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Image
            Container(
              width: double.infinity,
              height: 200,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF2E7D32), Color(0xFF66BB6A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.local_hospital,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'KLINIK KU',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Melayani dengan Sepenuh Hati',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Kontak
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('KONTAK KAMI'),
                  const SizedBox(height: 12),
                  _buildContactCard(
                    Icons.phone,
                    'Telepon',
                    '(021) 1234-5678',
                    Colors.blue,
                    () {},
                  ),
                  const SizedBox(height: 12),
                  _buildContactCard(
                    Icons.message,
                    'WhatsApp',
                    '+62 812-3456-7890',
                    Colors.green,
                    () {},
                  ),
                  const SizedBox(height: 12),
                  _buildContactCard(
                    Icons.email,
                    'Email',
                    'info@klinikku.com',
                    Colors.red,
                    () {},
                  ),
                  const SizedBox(height: 24),

                  // Alamat
                  _buildSectionTitle('ALAMAT'),
                  const SizedBox(height: 12),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.orange.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.location_on,
                                  color: Colors.orange,
                                  size: 28,
                                ),
                              ),
                              const SizedBox(width: 16),
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Lokasi Klinik',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'Jl. Kesehatan No. 123\nJakarta Selatan 12345\nIndonesia',
                                      style: TextStyle(
                                        fontSize: 13,
                                        height: 1.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Membuka Google Maps...'),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.map),
                              label: const Text('LIHAT DI MAPS'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Jam Operasional
                  _buildSectionTitle('JAM OPERASIONAL'),
                  const SizedBox(height: 12),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _buildJamRow('Senin - Jumat', '08:00 - 20:00'),
                          const Divider(height: 24),
                          _buildJamRow('Sabtu', '08:00 - 16:00'),
                          const Divider(height: 24),
                          _buildJamRow('Minggu', '08:00 - 12:00'),
                          const Divider(height: 24),
                          Row(
                            children: [
                              const Icon(Icons.emergency, color: Colors.red, size: 20),
                              const SizedBox(width: 8),
                              const Expanded(
                                child: Text(
                                  'Layanan Emergency 24 Jam',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Layanan
                  _buildSectionTitle('LAYANAN KAMI'),
                  const SizedBox(height: 12),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: layananProvider.activeLayananList.length,
                    itemBuilder: (context, index) {
                      final layanan = layananProvider.activeLayananList[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: const Color(0xFF2E7D32).withValues(alpha: 0.1),
                            child: const Icon(
                              Icons.medical_services,
                              color: Color(0xFF2E7D32),
                              size: 20,
                            ),
                          ),
                          title: Text(
                            layanan.nama,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Text(
                            layanan.deskripsi,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          trailing: Chip(
                            label: Text(
                              layanan.kategori,
                              style: const TextStyle(fontSize: 10),
                            ),
                            backgroundColor: Colors.blue.withValues(alpha: 0.1),
                            labelStyle: const TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),

                  // Fasilitas
                  _buildSectionTitle('FASILITAS'),
                  const SizedBox(height: 12),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        children: [
                          _buildFacilityItem(Icons.local_pharmacy, 'Apotek'),
                          _buildFacilityItem(Icons.science, 'Laboratorium'),
                          _buildFacilityItem(Icons.accessible, 'Kursi Roda'),
                          _buildFacilityItem(Icons.local_parking, 'Parkir'),
                          _buildFacilityItem(Icons.wifi, 'WiFi Gratis'),
                          _buildFacilityItem(Icons.restaurant, 'Kantin'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Social Media
                  _buildSectionTitle('IKUTI KAMI'),
                  const SizedBox(height: 12),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildSocialButton(Icons.facebook, Colors.blue),
                          _buildSocialButton(Icons.camera_alt, Colors.pink),
                          _buildSocialButton(Icons.play_circle, Colors.red),
                          _buildSocialButton(Icons.chat, Colors.green),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Color(0xFF2E7D32),
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildContactCard(
    IconData icon,
    String label,
    String value,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      value,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildJamRow(String hari, String jam) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          hari,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          jam,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }

  Widget _buildFacilityItem(IconData icon, String label) {
    return SizedBox(
      width: 80,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF2E7D32).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: const Color(0xFF2E7D32), size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton(IconData icon, Color color) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color, size: 28),
      ),
    );
  }
}