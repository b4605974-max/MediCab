import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/cabinet_service.dart';
import '../models/schedule.dart';

class AddEditScheduleScreen extends StatefulWidget {
  const AddEditScheduleScreen({super.key});

  @override
  State<AddEditScheduleScreen> createState() => _AddEditScheduleScreenState();
}

class _AddEditScheduleScreenState extends State<AddEditScheduleScreen> {
  final _service = CabinetService();
  final _formKey = GlobalKey<FormState>();

  String? _selectedMedicineId;
  TimeOfDay _selectedTime = const TimeOfDay(hour: 8, minute: 0);
  final _dosageDisplayController = TextEditingController(text: "1 Capsule with breakfast");
  String _category = "Daily Rx";

  bool _enableLedLight = true;
  bool _enableCabinetChime = true;
  bool _notifyCaregiver = false;

  final List<String> _daysOfWeek = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
  final Set<String> _selectedDays = {"Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"};

  @override
  void initState() {
    super.initState();
    if (_service.medicines.isNotEmpty) {
      _selectedMedicineId = _service.medicines.first.id;
    }
  }

  @override
  void dispose() {
    _dosageDisplayController.dispose();
    super.dispose();
  }

  void _saveSchedule() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedMedicineId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select a medication from your cabinet."),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final hour = _selectedTime.hourOfPeriod == 0 ? 12 : _selectedTime.hourOfPeriod;
    final minute = _selectedTime.minute.toString().padLeft(2, '0');
    final period = _selectedTime.period == DayPeriod.am ? "AM" : "PM";
    final timeStr = "$hour:$minute $period";

    final newSched = Schedule(
      id: "sched-${DateTime.now().millisecondsSinceEpoch}",
      medicineId: _selectedMedicineId!,
      timeString: timeStr,
      category: _category,
      dosageDisplay: _dosageDisplayController.text.trim(),
      status: ScheduleStatus.upcoming,
      enableLedGuide: _enableLedLight,
      enableCabinetChime: _enableCabinetChime,
    );

    _service.addSchedule(newSched);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Schedule set for $timeStr!"),
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
        title: const Text("Add Schedule", style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Medicine Selector
              const Text("Select Medication", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              if (_service.medicines.isEmpty)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text("No medicines in cabinet. Add one first!"),
                )
              else
                DropdownButtonFormField<String>(
                  value: _selectedMedicineId,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.medication, color: AppColors.primary),
                  ),
                  items: _service.medicines.map((m) {
                    return DropdownMenuItem(
                      value: m.id,
                      child: Text("${m.brandName} ${m.dosage} (${m.shelfSlot})"),
                    );
                  }).toList(),
                  onChanged: (val) => setState(() => _selectedMedicineId = val),
                ),
              const SizedBox(height: 16),

              // Intake Time
              const Text("Intake Time", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              InkWell(
                onTap: () async {
                  final picked = await showTimePicker(context: context, initialTime: _selectedTime);
                  if (!mounted) return;
                  if (picked != null) {
                    setState(() => _selectedTime = picked);
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
                          const Icon(Icons.access_time, color: AppColors.primary),
                          const SizedBox(width: 12),
                          Text(
                            _selectedTime.format(context),
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const Text(
                        "Change",
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Dosage Display & Meal notes
              TextFormField(
                controller: _dosageDisplayController,
                decoration: const InputDecoration(
                  labelText: "Dosage & Notes",
                  hintText: "e.g. 1 Capsule with breakfast",
                  prefixIcon: Icon(Icons.restaurant, color: AppColors.outline),
                ),
                validator: (val) => val == null || val.trim().isEmpty ? "Enter dosage instructions" : null,
              ),
              const SizedBox(height: 16),

              // Category Picker
              const Text("Schedule Category", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _category,
                decoration: const InputDecoration(prefixIcon: Icon(Icons.category, color: AppColors.secondary)),
                items: ["Daily Rx", "Antibiotics", "Vitamins & Supplements", "Sleep Routine", "As Needed"]
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (val) => setState(() => _category = val!),
              ),
              const SizedBox(height: 16),

              // Repeat Days
              const Text("Frequency & Days", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: _daysOfWeek.map((day) {
                  final isSelected = _selectedDays.contains(day);
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          if (_selectedDays.length > 1) {
                            _selectedDays.remove(day);
                          }
                        } else {
                          _selectedDays.add(day);
                        }
                      });
                    },
                    child: Container(
                      width: 42,
                      height: 42,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary : AppColors.surfaceContainerLowest,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected ? AppColors.primary : AppColors.surfaceContainer,
                        ),
                      ),
                      child: Text(
                        day,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : AppColors.onSurfaceVariant,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),

              // Hardware IoT Alert Options
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.surfaceContainer),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Hardware & Smart Alerts",
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      value: _enableLedLight,
                      activeColor: AppColors.primary,
                      title: const Text("LED Shelf Guide Light", style: TextStyle(fontSize: 13)),
                      subtitle: const Text("Illuminates the compartment slot at due time", style: TextStyle(fontSize: 11)),
                      onChanged: (val) => setState(() => _enableLedLight = val),
                    ),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      value: _enableCabinetChime,
                      activeColor: AppColors.primary,
                      title: const Text("Cabinet Chime Sound", style: TextStyle(fontSize: 13)),
                      subtitle: const Text("Gentle audio reminder from physical cabinet", style: TextStyle(fontSize: 11)),
                      onChanged: (val) => setState(() => _enableCabinetChime = val),
                    ),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      value: _notifyCaregiver,
                      activeColor: AppColors.primary,
                      title: const Text("Notify Caregiver", style: TextStyle(fontSize: 13)),
                      subtitle: const Text("Sends alert if dose is missed by >30 mins", style: TextStyle(fontSize: 11)),
                      onChanged: (val) => setState(() => _notifyCaregiver = val),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: _saveSchedule,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.event_available, size: 20),
                    SizedBox(width: 8),
                    Text("Save Schedule"),
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
