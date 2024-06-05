import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Internet Payment',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PaymentPage(),
    );
  }
}

class PaymentPage extends StatefulWidget {
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  ValueNotifier<bool> chooseAllNotifier = ValueNotifier(false);
  ValueNotifier<bool> item1Notifier = ValueNotifier(false);
  ValueNotifier<bool> item2Notifier = ValueNotifier(false);

  @override
  void initState() {
    super.initState();

    chooseAllNotifier.addListener(() {
      bool value = chooseAllNotifier.value;
      item1Notifier.value = value;
      item2Notifier.value = value;
    });

    item1Notifier.addListener(updateChooseAll);
    item2Notifier.addListener(updateChooseAll);

    item1Notifier.addListener(updateTotalPayment);
    item2Notifier.addListener(updateTotalPayment);
  }

  void updateChooseAll() {
    chooseAllNotifier.value = item1Notifier.value && item2Notifier.value;
  }

  void updateTotalPayment() {
    setState(() {
      // Hitung total pembayaran berdasarkan nilai kotak centang
      totalPayment = calculateTotalPayment();
    });
  }

  @override
  void dispose() {
    chooseAllNotifier.dispose();
    item1Notifier.dispose();
    item2Notifier.dispose();
    super.dispose();
  }

  double totalPayment = 0.0;

  double calculateTotalPayment() {
    double total = 0;
    if (item1Notifier.value) total += 450000;
    if (item2Notifier.value) total += 240000;
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Internet')),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Implement back button functionality
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(8.0),
              color: Colors.yellow[100],
              child: Row(
                children: [
                  Icon(Icons.info, color: Colors.yellow[700]),
                  SizedBox(width: 8.0),
                  Expanded(
                    child: Text(
                      'Perlu diketahui, proses verifikasi transaksi dapat memakan waktu hingga 1x24 jam.',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                ValueListenableBuilder<bool>(
                  valueListenable: chooseAllNotifier,
                  builder: (context, value, child) {
                    return Checkbox(
                      value: value,
                      onChanged: (bool? newValue) {
                        chooseAllNotifier.value = newValue!;
                        // Set item1Notifier and item2Notifier accordingly
                        item1Notifier.value = newValue;
                        item2Notifier.value = newValue;
                      },
                      activeColor: Colors.red, // Ubah warna checkbox menjadi merah
                    );
                  },
                ),
                Text('Choose All'),
              ],
            ),
            Expanded(
              child: ListView(
                children: [
                  ValueListenableBuilder<bool>(
                    valueListenable: item1Notifier,
                    builder: (context, value, child) {
                      return BillItem(
                        amount: 'Rp450.000',
                        dueDate: '16 Feb 2024',
                        provider: 'Nethome',
                        customerId: '1123645718921',
                        servicePackage: 'Nethome 100 Mbps',
                        isChecked: value,
                        onChanged: (newValue) {
                          item1Notifier.value = newValue;
                        },
                      );
                    },
                  ),
                  ValueListenableBuilder<bool>(
                    valueListenable: item2Notifier,
                    builder: (context, value, child) {
                      return BillItem(
                        amount: 'Rp240.000',
                        dueDate: '20 Feb 2024',
                        provider: '',
                        customerId: '',
                        servicePackage: '',
                        isChecked: value,
                        onChanged: (newValue) {
                          item2Notifier.value = newValue;
                        },
                      );
                    },
                  ),
                  SizedBox(height: 16.0),
                  TextButton(
                    onPressed: () {
                      // Implement transaction history functionality
                    },
                    child: Text('Transaction History', style: TextStyle(color: Colors.red)), // Ubah warna teks menjadi merah
                  ),
                ],
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment
                    .start, // Mengatur posisi vertical ke start (atas)
                children: [
                  Text(
                    'Total Payment',
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Rp ${totalPayment.toStringAsFixed(0)}',
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Implement payment functionality
              },
              child: Text('PAY NOW', style: TextStyle(color: Colors.white)), // Ubah warna teks menjadi putih
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                minimumSize: Size(double.infinity, 48.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BillItem extends StatefulWidget {
  final String amount;
  final String dueDate;
  final String provider;
  final String customerId;
  final String servicePackage;
  final bool isChecked;
  final ValueChanged<bool> onChanged;

  BillItem({
    required this.amount,
    required this.dueDate,
    required this.provider,
    required this.customerId,
    required this.servicePackage,
    required this.isChecked,
    required this.onChanged,
  });

  @override
  _BillItemState createState() => _BillItemState();
}

class _BillItemState extends State<BillItem>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Checkbox(
                  value: widget.isChecked,
                  onChanged: (bool? value) {
                    widget.onChanged(value!);
                  },
                  activeColor: Colors.red, // Ubah warna checkbox menjadi merah
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.amount, style: TextStyle(fontSize: 16.0)),
                    Text('Due date on ${widget.dueDate}',
                        style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ],
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: Visibility(
              visible: _isExpanded,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.provider.isNotEmpty)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Provider',
                              style: TextStyle(color: Colors.grey)),
                          Text(widget.provider),
                        ],
                      ),
                    SizedBox(height: 4.0),
                    if (widget.customerId.isNotEmpty)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('ID Pelanggan',
                              style: TextStyle(color: Colors.grey)),
                          Text(widget.customerId),
                        ],
                      ),
                    SizedBox(height: 4.0),
                    if (widget.servicePackage.isNotEmpty)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Paket Layanan',
                              style: TextStyle(color: Colors.grey)),
                          Text(widget.servicePackage),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
          Center(
            child: TextButton(
              onPressed: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              child: Text(
                _isExpanded ? 'Close' : 'See Details',
                style: TextStyle(color: Colors.red), // Ubah warna teks menjadi merah
              ),
            ),
          ),
        ],
      ),
    );
  }
}
