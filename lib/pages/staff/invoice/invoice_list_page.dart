// lib/pages/staff/invoice/invoice_list_page.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'invoice_form_page.dart';

class InvoiceListPage extends StatefulWidget {
  const InvoiceListPage({super.key});

  @override
  State<InvoiceListPage> createState() => _InvoiceListPageState();
}

class _InvoiceListPageState extends State<InvoiceListPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Dummy data
  final List<Map<String, dynamic>> _invoiceList = [
    {
      'id': '1',
      'noInvoice': 'INV-20240101-0001',
      'pasienNama': 'Budi Santoso',
      'pasienNoRm': 'RM001',
      'tanggal': '2024-01-01',
      'total': 350000.0,
      'status': 'lunas',
      'metodePembayaran': 'Tunai',
    },
    {
      'id': '2',
      'noInvoice': 'INV-20240101-0002',
      'pasienNama': 'Siti Aminah',
      'pasienNoRm': 'RM002',
      'tanggal': '2024-01-01',
      'total': 450000.0,
      'status': 'belum',
      'metodePembayaran': null,
    },
    {
      'id': '3',
      'noInvoice': 'INV-20240101-0003',
      'pasienNama': 'Agus Wijaya',
      'pasienNoRm': 'RM003',
      'tanggal': '2024-01-01',
      'total': 275000.0,
      'status': 'sebagian',
      'metodePembayaran': 'Transfer',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredList {
    List<Map<String, dynamic>> list = _invoiceList;

    if (_searchQuery.isNotEmpty) {
      final lowerQuery = _searchQuery.toLowerCase();
      list = list.where((invoice) {
        return invoice['pasienNama'].toLowerCase().contains(lowerQuery) ||
            invoice['noInvoice'].toLowerCase().contains(lowerQuery) ||
            invoice['pasienNoRm'].toLowerCase().contains(lowerQuery);
      }).toList();
    }

    return list;
  }

  Map<String, int> get _statistics {
    return {
      'total': _invoiceList.length,
      'belum': _invoiceList.where((i) => i['status'] == 'belum').length,
      'sebagian': _invoiceList.where((i) => i['status'] == 'sebagian').length,
      'lunas': _invoiceList.where((i) => i['status'] == 'lunas').length,
    };
  }

  @override
  Widget build(BuildContext context) {
    final stats = _statistics;

    return Scaffold(
      appBar: AppBar(
        title: const Text('INVOICE & PEMBAYARAN'),
        backgroundColor: const Color(0xFF2E7D32),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: [
            Tab(text: 'Semua\n(${stats['total']})'),
            Tab(text: 'Belum Lunas\n(${stats['belum']! + stats['sebagian']!})'),
            Tab(text: 'Lunas\n(${stats['lunas']})'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Statistics Summary
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[100],
            child: Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Total Invoice',
                    stats['total'].toString(),
                    Icons.receipt_long,
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildStatCard(
                    'Belum Bayar',
                    stats['belum'].toString(),
                    Icons.pending,
                    Colors.orange,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildStatCard(
                    'Lunas',
                    stats['lunas'].toString(),
                    Icons.check_circle,
                    Colors.green,
                  ),
                ),
              ],
            ),
          ),

          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari invoice, pasien, no. RM...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),

          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildInvoiceList(_filteredList),
                _buildInvoiceList(_filteredList
                    .where((i) => i['status'] != 'lunas')
                    .toList()),
                _buildInvoiceList(
                    _filteredList.where((i) => i['status'] == 'lunas').toList()),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const InvoiceFormPage(),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('BUAT INVOICE'),
        backgroundColor: const Color(0xFF2E7D32),
      ),
    );
  }

  Widget _buildStatCard(
      String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildInvoiceList(List<Map<String, dynamic>> list) {
    if (list.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_outlined,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Tidak ada invoice',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final invoice = list[index];
        return _buildInvoiceCard(invoice);
      },
    );
  }

  Widget _buildInvoiceCard(Map<String, dynamic> invoice) {
    Color statusColor = _getStatusColor(invoice['status']);
    IconData statusIcon = _getStatusIcon(invoice['status']);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _showInvoiceDetail(invoice),
        borderRadius: BorderRadius.circular(12),
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
                      color: statusColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.receipt_long, color: statusColor, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          invoice['noInvoice'],
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          invoice['pasienNama'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'RM: ${invoice['pasienNoRm']}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(statusIcon, size: 16, color: statusColor),
                        const SizedBox(width: 4),
                        Text(
                          _getStatusText(invoice['status']),
                          style: TextStyle(
                            color: statusColor,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Tagihan',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Rp ${NumberFormat('#,###').format(invoice['total'])}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E7D32),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Tanggal',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        DateFormat('dd MMM yyyy', 'id_ID')
                            .format(DateTime.parse(invoice['tanggal'])),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if (invoice['metodePembayaran'] != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.payment, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 6),
                    Text(
                      'Metode: ${invoice['metodePembayaran']}',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _showInvoiceDetail(invoice),
                      icon: const Icon(Icons.visibility),
                      label: const Text('LIHAT'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF2E7D32),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (invoice['status'] != 'lunas')
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _showPaymentDialog(invoice),
                        icon: const Icon(Icons.payment),
                        label: const Text('BAYAR'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2E7D32),
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  if (invoice['status'] == 'lunas')
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Cetak invoice'),
                            ),
                          );
                        },
                        icon: const Icon(Icons.print),
                        label: const Text('CETAK'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.blue,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'belum':
        return Colors.orange;
      case 'sebagian':
        return Colors.blue;
      case 'lunas':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'belum':
        return Icons.pending;
      case 'sebagian':
        return Icons.hourglass_bottom;
      case 'lunas':
        return Icons.check_circle;
      default:
        return Icons.info;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'belum':
        return 'Belum Bayar';
      case 'sebagian':
        return 'Dibayar Sebagian';
      case 'lunas':
        return 'Lunas';
      default:
        return status;
    }
  }

  void _showInvoiceDetail(Map<String, dynamic> invoice) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Detail Invoice'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('No. Invoice', invoice['noInvoice']),
              _buildDetailRow('Pasien', invoice['pasienNama']),
              _buildDetailRow('No. RM', invoice['pasienNoRm']),
              _buildDetailRow('Tanggal', DateFormat('dd MMMM yyyy', 'id_ID')
                  .format(DateTime.parse(invoice['tanggal']))),
              _buildDetailRow('Total',
                  'Rp ${NumberFormat('#,###').format(invoice['total'])}'),
              _buildDetailRow('Status', _getStatusText(invoice['status'])),
              if (invoice['metodePembayaran'] != null)
                _buildDetailRow('Metode Pembayaran', invoice['metodePembayaran']),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('TUTUP'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[600],
              ),
            ),
          ),
          const Text(': '),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showPaymentDialog(Map<String, dynamic> invoice) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pembayaran'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Total: Rp ${NumberFormat('#,###').format(invoice['total'])}'),
            const SizedBox(height: 16),
            const Text('Fitur pembayaran akan segera hadir'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('TUTUP'),
          ),
        ],
      ),
    );
  }
}