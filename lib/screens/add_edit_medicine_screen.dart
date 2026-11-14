import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/cabinet_service.dart';
import '../models/medicine.dart';

class AddEditMedicineScreen extends StatefulWidget {
  const AddEditMedicineScreen({super.key});

  @override
  State<AddEditMedicineScreen> createState() => _AddEditMedicineScreenState();
}

class _AddEditMedicineScreenState extends State<AddEditMedicineScreen> {
  final _service = CabinetService();
  final _formKey = GlobalKey<FormState>();

  final _brandController = TextEditingController();
  final _genericController = TextEditingController();
  final _dosageController = TextEditingController(text: "500mg");
  final _instructionsController = TextEditingController(text: "Take 1 capsule with food");

  String _selectedShelfId = "shelf-1";
  String _selectedForm = "Capsule";
  int _stockCount = 30;
  DateTime _expiryDate = DateTime.now().add(const Duration(days: 365));

  @override
  void dispose() {
    _brandController.dispose();
    _genericController.dispose();
    _dosageController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  void _saveMedicine() {
    if (!_formKey.currentState!.validate()) return;

    final newMed = Medicine(
      id: "med-${DateTime.now().millisecondsSinceEpoch}",
      brandName: _brandController.text.trim(),
      genericName: _genericController.text.trim(),
      dosage: _dosageController.text.trim(),
      form: _selectedForm,
      shelfId: _selectedShelfId,
      shelfSlot: _selectedShelfId == "shelf-1"
          ? "Top Shelf • Slot A"
          : _selectedShelfId == "shelf-2"
              ? "Middle Shelf • Slot B"
              : "Bottom Drawer • Slot C",
      totalStock: _stockCount,
      currentStock: _stockCount,
      expiryDate: _expiryDate,
      instructions: _instructionsController.text.trim(),
      tags: ["Active Prescription"],
    );

    _service.addMedicine(newMed);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Added ${newMed.brandName} to Cabinet!"),
        backgroundColor: AppColors.primary,
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const Text("Add Medicine", style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _brandController,
                decoration: const InputDecoration(
                  labelText: "Medicine Brand Name",
                  hintText: "e.g. Amoxicillin, Lipitor",
                  prefixIcon: Icon(Icons.medication, color: AppColors.outline),
                ),
                validator: (val) => val == null || val.trim().isEmpty ? "Enter medicine name" : null,
              ),
              const SizedBox(height: 14),

              TextFormField(
                controller: _genericController,
                decoration: const InputDecoration(
                  labelText: "Generic Formulation",
                  hintText: "e.g. Amoxicillin Trihydrate",
                  prefixIcon: Icon(Icons.science, color: AppColors.outline),
                ),
              ),
              const SizedBox(height: 14),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _dosageController,
                      decoration: const InputDecoration(
                        labelText: "Dosage Strength",
                        hintText: "500mg",
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedForm,
                      decoration: const InputDecoration(labelText: "Form"),
                      items: ["Capsule", "Tablet", "Liquid Syrup", "Spray", "Inhaler"]
                          .map((f) => DropdownMenuItem(value: f, child: Text(f)))
                          .toList(),
                      onChanged: (val) => setState(() => _selectedForm = val!),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Shelf Drawer Assignment
              const Text("Cabinet Shelf Assignment", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedShelfId,
                decoration: const InputDecoration(prefixIcon: Icon(Icons.shelves, color: AppColors.primary)),
                items: const [
                  DropdownMenuItem(value: "shelf-1", child: Text("Top Shelf (Daily Prescriptions)")),
                  DropdownMenuItem(value: "shelf-2", child: Text("Middle Shelf (First Aid & OTC)")),
                  DropdownMenuItem(value: "shelf-3", child: Text("Bottom Drawer (Pediatric / Locked)")),
                ],
                onChanged: (val) => setState(() => _selectedShelfId = val!),
              ),
              const SizedBox(height: 16),

              // Expiry Date Selector
              const Text("Expiration Date", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              InkWell(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _expiryDate,
                    firstDate: DateTime.now().subtract(const Duration(days: 30)),
                    lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
                  );
                  if (!mounted) return;
                  if (picked != null) {
                    setState(() => _expiryDate = picked);
                  }
                },
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.surfaceContainer),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.calendar_today, color: AppColors.primary, size: 20),
                          const SizedBox(width: 12),
                          Text(
                            "${_expiryDate.year}-${_expiryDate.month.toString().padLeft(2, '0')}-${_expiryDate.day.toString().padLeft(2, '0')}",
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      const Text(
                        "Change",
                        style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Stock Count Stepper
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.surfaceContainer),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Current Pill/Unit Stock", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        Text("Monitored via internal cabinet weight", style: TextStyle(fontSize: 11, color: AppColors.outline)),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton.filledTonal(
                          onPressed: () {
                            if (_stockCount > 1) setState(() => _stockCount--);
                          },
                          icon: const Icon(Icons.remove, size: 18),
                        ),
                        SizedBox(
                          width: 40,
                          child: Text(
                            "$_stockCount",
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        IconButton.filledTonal(
                          onPressed: () => setState(() => _stockCount++),
                          icon: const Icon(Icons.add, size: 18),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _instructionsController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: "Usage Instructions",
                  hintText: "Take 1 capsule with food and a full glass of water",
                ),
              ),
              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: _saveMedicine,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.save, size: 20),
                    SizedBox(width: 8),
                    Text("Save to Cabinet"),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
