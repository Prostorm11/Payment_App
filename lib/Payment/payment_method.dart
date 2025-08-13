import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PaymentMethod extends StatefulWidget {
  const PaymentMethod({super.key});

  @override
  State<PaymentMethod> createState() => _PaymentMethodState();
}

class _PaymentMethodState extends State<PaymentMethod> {
  final _formKey = GlobalKey<FormState>();
  String? selectedNetwork;
  final TextEditingController phoneController = TextEditingController();
  bool isLoading = false;

  final List<String> networks = [
    "MTN Mobile Money",
    "Vodafone Cash",
    "AirtelTigo Money"
  ];

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Choose Mobile Money Service",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                semanticsLabel: "Select mobile money service",
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: selectedNetwork,
                hint: const Text("Select network"),
                items: networks.map((network) {
                  return DropdownMenuItem(
                    value: network,
                    child: Text(network),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedNetwork = value;
                  });
                },
                validator: (value) => value == null ? "Please select a network" : null,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Enter Mobile Number",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                semanticsLabel: "Enter mobile number",
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your number";
                  }
                  if (!RegExp(r'^(0[23567][0-9]{8})$').hasMatch(value)) {
                    return "Enter a valid Ghanaian mobile number (e.g., 024xxxxxxx)";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: "e.g. 024xxxxxxx",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.phone),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              isLoading = true;
                            });
                            // Simulate async operation (e.g., API call)
                            await Future.delayed(const Duration(seconds: 1));
                            if (mounted) {
                              Navigator.of(context).pop({
                                "network": selectedNetwork,
                                "number": phoneController.text,
                              });
                              setState(() {
                                isLoading = false;
                              });
                            }
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    disabledBackgroundColor: Colors.deepPurple.withOpacity(0.5),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          "Proceed",
                          style: TextStyle(fontSize: 16),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}