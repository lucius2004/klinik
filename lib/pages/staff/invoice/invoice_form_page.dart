// lib/pages/staff/invoice/invoice_form_page.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../providers/pendaftaran_provider.dart';
import '../../../models/pendaftaran_model.dart';

class InvoiceFormPage extends StatefulWidget {
  const InvoiceFormPage({super.key});

  @override
  State<InvoiceFormPage> createState() => _InvoiceFormPageState();
}

class _InvoiceFormPageState extends State<InvoiceFormPage> {
  final _formKey = GlobalKey<FormState>();
  
  String? _selectedPendaftaranId;
  PendaftaranModel? _selectedPendaftaran;

  // Invoice items
  final List<Map<String, dynamic>> _items = [];
  
  // Controllers for adding item
  final _itemNamaController = TextEditingController();
  final _itemJumlahController = TextEditingController(text: '1');
  final _itemHargaController = TextEditingController();
  String _itemType = 'Layanan';

  // Additional charges
  final _diskonController = TextEditingController(text: '0');
  final _biayaAdminController = TextEditingController(text: '0');
  final _catatanController = TextEditingController();

  @override
  void dispose() {
    _itemNamaController.dispose();
    _itemJumlahController.dispose();
    _itemHargaController.dispose();
    _diskonController.dispose();
    _biayaAdminController.dispose();
    _catatanController.dispose();
    super.dispose();
  }

  double get _subtotal {
    return _items.fold(0.0, (sum, item) => sum + item['subtotal']);
  }

  double get _diskon {
    return double.tryParse(_diskonController.text) ?? 0;
  }

  double get _biayaAdmin {
    return double.tryParse(_biayaAdminController.text) ?? 0;
  }

  double get _grandTotal {
    return _subtotal - _diskon + _biayaAdmin;
  }

  @override
  Widget build(BuildContext context) {
    final pendaftaranProvider = Provider.of<PendaftaranProvider>(context);
    final selesaiList = pendaftaranProvider.getPendaftaranByStatus('selesai');

    return Scaffold(
      appBar: AppBar(
        title: const Text('BUAT INVOICE'),
        backgroundColor: const Color(0xFF2E7D32),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Info Card
                    Card(
                      color: Colors.indigo[50],
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Icon(Icons.receipt_long, color: Colors.indigo[700]),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Buat invoice untuk pasien yang sudah selesai diperiksa',
                                style: TextStyle(color: Colors.indigo[900]),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Pilih Pasien
                    const Text(
                      'Pilih Pasien',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: _selectedPendaftaranId,
                      decoration: InputDecoration(
                        labelText: 'Pasien yang sudah selesai',
                        prefixIcon: const Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.grey[50],
                      ),
                      items: selesaiList.map((pendaftaran) {
                        return DropdownMenuItem(
                          value: pendaftaran.id,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(pendaftaran.pasienNama),
                              Text(
                                'RM: ${pendaftaran.pasienNoRm} | ${pendaftaran.dokterNama}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedPendaftaranId = value;
                          _selectedPendaftaran = pendaftaranProvider
                              .getPendaftaranById(value!);
                          // Auto add layanan as first item
                          if (_items.isEmpty && _selectedPendaftaran != null) {
                            _items.add({
                              'type': 'Layanan',
                              'nama': _selectedPendaftaran!.layananNama,
                              'jumlah': 1,
                              'harga': 150000.0, // Default price
                              'subtotal': 150000.0,
                            });
                          }
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Pilih pasien terlebih dahulu';
                        }
                        return null;
                      },
                    ),

                    if (_selectedPendaftaran != null) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.blue[200]!),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.info, color: Colors.blue[700], size: 20),
                                const SizedBox(width: 8),
                                const Text(
                                  'Informasi Kunjungan',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text('No. Pendaftaran: ${_selectedPendaftaran!.noPendaftaran}'),
                            Text('Tanggal: ${_selectedPendaftaran!.tanggalDaftar}'),
                            Text('Layanan: ${_selectedPendaftaran!.layananNama}'),
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: 24),

                    // Item Invoice
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Item Invoice',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton.icon(
                          onPressed: _showAddItemDialog,
                          icon: const Icon(Icons.add_circle_outline),
                          label: const Text('TAMBAH'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Items List
                    if (_items.isEmpty)
                      Container(
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(Icons.shopping_cart_outlined,
                                  size: 48, color: Colors.grey[400]),
                              const SizedBox(height: 8),
                              Text(
                                'Belum ada item',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _items.length,
                        itemBuilder: (context, index) {
                          final item = _items[index];
                          return Card(
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: const Color(0xFF2E7D32).withValues(alpha: 0.1),
                                child: Icon(
                                  _getItemIcon(item['type']),
                                  color: const Color(0xFF2E7D32),
                                  size: 20,
                                ),
                              ),
                              title: Text(item['nama']),
                              subtitle: Text(
                                '${item['type']} • ${item['jumlah']}x @ Rp ${NumberFormat('#,###').format(item['harga'])}',
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Rp ${NumberFormat('#,###').format(item['subtotal'])}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {
                                      setState(() {
                                        _items.removeAt(index);
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),

                    const SizedBox(height: 24),

                    // Calculation Section
                    const Text(
                      'Perhitungan',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _diskonController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            decoration: InputDecoration(
                              labelText: 'Diskon (Rp)',
                              prefixIcon: const Icon(Icons.discount),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: Colors.grey[50],
                            ),
                            onChanged: (value) => setState(() {}),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _biayaAdminController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            decoration: InputDecoration(
                              labelText: 'Biaya Admin (Rp)',
                              prefixIcon: const Icon(Icons.add_circle_outline),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: Colors.grey[50],
                            ),
                            onChanged: (value) => setState(() {}),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Catatan
                    TextFormField(
                      controller: _catatanController,
                      maxLines: 2,
                      decoration: InputDecoration(
                        labelText: 'Catatan (Opsional)',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.grey[50],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Summary Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.2),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Subtotal',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      Text(
                        'Rp ${NumberFormat('#,###').format(_subtotal)}',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ],
                  ),
                  if (_diskon > 0) ...[
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Diskon',
                          style: TextStyle(color: Colors.red),
                        ),
                        Text(
                          '- Rp ${NumberFormat('#,###').format(_diskon)}',
                          style: const TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ],
                  if (_biayaAdmin > 0) ...[
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Biaya Admin',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        Text(
                          'Rp ${NumberFormat('#,###').format(_biayaAdmin)}',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ],
                    ),
                  ],
                  const Divider(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'TOTAL',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Rp ${NumberFormat('#,###').format(_grandTotal)}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E7D32),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _items.isEmpty ? null : _handleSubmit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2E7D32),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'BUAT INVOICE',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getItemIcon(String type) {
    switch (type) {
      case 'Layanan':
        return Icons.medical_services;
      case 'Tindakan':
        return Icons.healing;
      case 'Obat':
        return Icons.medication;
      default:
        return Icons.shopping_bag;
    }
  }

  void _showAddItemDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tambah Item'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: _itemType,
                decoration: const InputDecoration(
                  labelText: 'Tipe Item',
                  border: OutlineInputBorder(),
                ),
                items: ['Layanan', 'Tindakan', 'Obat', 'Lainnya']
                    .map((type) => DropdownMenuItem(
                          value: type,
                          child: Text(type),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _itemType = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _itemNamaController,
                decoration: const InputDecoration(
                  labelText: 'Nama Item',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _itemJumlahController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  labelText: 'Jumlah',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _itemHargaController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  labelText: 'Harga Satuan (Rp)',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('BATAL'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_itemNamaController.text.isNotEmpty &&
                  _itemHargaController.text.isNotEmpty) {
                final jumlah = int.tryParse(_itemJumlahController.text) ?? 1;
                final harga = double.tryParse(_itemHargaController.text) ?? 0;
                
                setState(() {
                  _items.add({
                    'type': _itemType,
                    'nama': _itemNamaController.text,
                    'jumlah': jumlah,
                    'harga': harga,
                    'subtotal': jumlah * harga,
                  });
                });

                _itemNamaController.clear();
                _itemJumlahController.text = '1';
                _itemHargaController.clear();
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E7D32),
            ),
            child: const Text('TAMBAH'),
          ),
        ],
      ),
    );
  }

  void _handleSubmit() {
    if (!_formKey.currentState!.validate()) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 28),
            SizedBox(width: 10),
            Text('Berhasil!'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Invoice berhasil dibuat'),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'No. Invoice: INV-${DateFormat('yyyyMMdd').format(DateTime.now())}-0001',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text('Pasien: ${_selectedPendaftaran?.pasienNama}'),
                  Text('Total: Rp ${NumberFormat('#,###').format(_grandTotal)}'),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('SELESAI'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Navigate to payment
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Lanjut ke pembayaran'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E7D32),
            ),
            child: const Text('BAYAR SEKARANG'),
          ),
        ],
      ),
    );
  }
}