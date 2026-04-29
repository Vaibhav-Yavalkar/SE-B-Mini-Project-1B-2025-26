// lib/screens/retailer_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_theme.dart';
import '../app_provider.dart';
import '../models/models.dart';

class RetailerScreen extends StatefulWidget {
  final FoodBag? editBag;
  const RetailerScreen({super.key, this.editBag});

  @override
  State<RetailerScreen> createState() => _RetailerScreenState();
}

class _RetailerScreenState extends State<RetailerScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameCtrl;
  late TextEditingController _descCtrl;
  late TextEditingController _priceCtrl;
  late TextEditingController _quantityCtrl;
  late TextEditingController _sizeCtrl; // Handles both kg and ml
  late String _category;
  late bool _isLiquid;
  late TimeOfDay _pickupStart;
  late TimeOfDay _pickupEnd;
  bool _submitted = false;

  final _categories = ['Bakery', 'Restaurant', 'Café', 'Sweets', 'Japanese', 'Other'];

  @override
  void initState() {
    super.initState();
    final bag = widget.editBag;
    _nameCtrl = TextEditingController(text: bag?.restaurantName ?? 'My Restaurant');
    _descCtrl = TextEditingController(text: bag?.description ?? '');
    _priceCtrl = TextEditingController(text: bag?.originalPrice.toInt().toString() ?? '');
    _quantityCtrl = TextEditingController(text: bag?.quantity.toString() ?? '5');
    _isLiquid = bag?.isLiquid ?? false;
    _sizeCtrl = TextEditingController(
        text: _isLiquid ? bag?.volumeMl.toString() : bag?.weightKg.toString() ?? '0.8');
    _category = bag?.category ?? 'Restaurant';
    _pickupStart = const TimeOfDay(hour: 18, minute: 0);
    _pickupEnd = const TimeOfDay(hour: 20, minute: 0);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _priceCtrl.dispose();
    _quantityCtrl.dispose();
    _sizeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_submitted) return _buildSuccess(context);

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text(widget.editBag == null ? 'List a Surprise Bag' : 'Edit Surprise Bag'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        physics: const BouncingScrollPhysics(),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionLabel('Business Details'),
              const SizedBox(height: 10),
              _buildTextField(
                controller: _nameCtrl,
                label: 'Restaurant / Business Name',
                icon: Icons.store_rounded,
              ),
              const SizedBox(height: 12),
              _buildTextField(
                controller: _descCtrl,
                label: 'Describe what\'s in the bag',
                icon: Icons.description_rounded,
                maxLines: 3,
                hint: 'e.g. Assorted pastries, bread, and muffins...',
              ),
              const SizedBox(height: 20),
              _buildSectionLabel('Bag Details'),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _priceCtrl,
                      label: 'Original Price (₹)',
                      icon: Icons.payments_rounded,
                      keyboardType: TextInputType.number,
                      onChanged: (v) => setState(() {}),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTextField(
                      controller: _quantityCtrl,
                      label: 'Quantity',
                      icon: Icons.inventory_2_rounded,
                      keyboardType: TextInputType.number,
                      onChanged: (v) => setState(() {}),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _sizeCtrl,
                      label: _isLiquid ? 'Volume (ml)' : 'Weight (kg)',
                      icon: _isLiquid ? Icons.water_drop_rounded : Icons.scale_rounded,
                      keyboardType: TextInputType.number,
                      onChanged: (v) => setState(() {}),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    children: [
                      const Text('Is Liquid?', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                      Switch(
                        value: _isLiquid,
                        activeColor: AppTheme.primary,
                        onChanged: (v) => setState(() {
                          _isLiquid = v;
                          _sizeCtrl.text = v ? '500' : '0.8';
                        }),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildDropdown(),
              const SizedBox(height: 20),
              _buildSectionLabel('Pickup Window'),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _buildTimePicker(
                      label: 'From',
                      time: _pickupStart,
                      onTap: () => _pickTime(true),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTimePicker(
                      label: 'Until',
                      time: _pickupEnd,
                      onTap: () => _pickTime(false),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildImpactPreview(),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: _submit,
                  icon: const Icon(Icons.check_circle_rounded, size: 20),
                  label: Text(widget.editBag == null ? 'Post Surprise Bag' : 'Save Changes'),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w800,
        color: AppTheme.textPrimary,
        letterSpacing: -0.2,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    String? hint,
    TextInputType? keyboardType,
    Function(String)? onChanged,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, size: 18, color: AppTheme.textLight),
        labelStyle: const TextStyle(fontSize: 13, color: AppTheme.textSecondary),
      ),
      validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
    );
  }

  Widget _buildDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _category,
          isExpanded: true,
          icon: const Icon(Icons.expand_more_rounded, color: AppTheme.textLight),
          style: const TextStyle(fontSize: 14, color: AppTheme.textPrimary, fontFamily: 'Nunito'),
          items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
          onChanged: (v) => setState(() => _category = v!),
        ),
      ),
    );
  }

  Widget _buildTimePicker({required String label, required TimeOfDay time, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(color: AppTheme.surfaceVariant, borderRadius: BorderRadius.circular(12)),
        child: Row(
          children: [
            const Icon(Icons.schedule_rounded, size: 16, color: AppTheme.textLight),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
                Text(time.format(context), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImpactPreview() {
    final price = double.tryParse(_priceCtrl.text) ?? 0;
    final qty = int.tryParse(_quantityCtrl.text) ?? 0;
    final sizeValue = double.tryParse(_sizeCtrl.text) ?? 0;
    
    final discounted = (price * 0.3).roundToDouble();
    final effectiveKg = _isLiquid ? (sizeValue / 1000.0) : sizeValue;
    final co2 = qty * effectiveKg * 2.5;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFFEAF3DE), Color(0xFFD4EDDA)]),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.primaryLight.withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Text('🌱', style: TextStyle(fontSize: 16)),
              SizedBox(width: 6),
              Text('Estimated Impact Preview', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppTheme.primary)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _ImpactPreviewTile(value: '${(qty * effectiveKg).toStringAsFixed(1)} kg', label: 'Food saved'),
              const SizedBox(width: 8),
              _ImpactPreviewTile(value: '${co2.toStringAsFixed(1)} kg', label: 'CO₂ prevented'),
              const SizedBox(width: 8),
              _ImpactPreviewTile(value: '₹${discounted.toInt()}', label: 'New Price'),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _pickTime(bool isStart) async {
    final t = await showTimePicker(context: context, initialTime: isStart ? _pickupStart : _pickupEnd);
    if (t != null) setState(() { if (isStart) _pickupStart = t; else _pickupEnd = t; });
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final price = double.tryParse(_priceCtrl.text) ?? 0;
      final qty = int.tryParse(_quantityCtrl.text) ?? 0;
      final sizeValue = double.tryParse(_sizeCtrl.text) ?? 0;
      final discounted = (price * 0.3).roundToDouble();

      final newBag = FoodBag(
        id: widget.editBag?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        restaurantName: _nameCtrl.text,
        restaurantImage: widget.editBag?.restaurantImage ?? 'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=400',
        description: _descCtrl.text,
        originalPrice: price,
        discountedPrice: discounted,
        quantity: qty,
        reserved: widget.editBag?.reserved ?? 0,
        lat: widget.editBag?.lat ?? 19.2403,
        lng: widget.editBag?.lng ?? 73.1305,
        address: widget.editBag?.address ?? 'Kalyan West, Maharashtra',
        pickupStart: _pickupStart.format(context),
        pickupEnd: _pickupEnd.format(context),
        tags: [_category, 'Veg'],
        weightKg: _isLiquid ? 0.0 : sizeValue,
        volumeMl: _isLiquid ? sizeValue.toInt() : 0,
        isLiquid: _isLiquid,
        category: _category,
        isVeg: true,
      );

      if (widget.editBag != null) {
        context.read<AppProvider>().updateFoodBag(newBag);
      } else {
        context.read<AppProvider>().addFoodBag(newBag);
      }
      setState(() => _submitted = true);
    }
  }

  Widget _buildSuccess(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('🎉', style: TextStyle(fontSize: 44)),
              const SizedBox(height: 20),
              Text(widget.editBag == null ? 'Bag Listed!' : 'Bag Updated!',
                  style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: AppTheme.textPrimary)),
              const SizedBox(height: 28),
              SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Back to Admin Panel'))),
            ],
          ),
        ),
      ),
    );
  }
}

class _ImpactPreviewTile extends StatelessWidget {
  final String value;
  final String label;
  const _ImpactPreviewTile({required this.value, required this.label});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
        decoration: BoxDecoration(color: AppTheme.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
        child: Column(children: [
          Text(value, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: AppTheme.primary)),
          Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 9, color: AppTheme.textSecondary)),
        ]),
      ),
    );
  }
}
