import 'package:chatgpt/constant/constants.dart';
import 'package:chatgpt/models/models_model.dart';
import 'package:chatgpt/providers/models_provider.dart';
import 'package:chatgpt/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ModelDownWidget extends StatefulWidget {
  const ModelDownWidget({super.key});

  @override
  State<ModelDownWidget> createState() {
    return _ModelDownWidgetState();
  }
}

class _ModelDownWidgetState extends State<ModelDownWidget> {
  String? currentModel;
  @override
  Widget build(BuildContext context) {
    final modelProvider = Provider.of<ModelsProvider>(context, listen: false);
    currentModel = modelProvider.getcurrentModel;
    return FutureBuilder<List<ModelsModel>>(
      future: modelProvider.getAllModels(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: TextWidget(
              label: "Error: ${snapshot.error}",
              color: Colors.red,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          );
        }
        return snapshot.data == null || snapshot.data!.isEmpty
            ? const SizedBox.shrink()
            : DropdownButton<String?>(
                dropdownColor: scaffoldBackgroundColor,
                iconEnabledColor: Colors.white,
                items: List<DropdownMenuItem<String?>>.generate(
                  snapshot.data!.length,
                  (index) {
                    return DropdownMenuItem(
                      value: snapshot.data![index].id,
                      child: TextWidget(
                        label: snapshot.data![index].id ?? 'Unknown ID',
                        fontSize: 16,
                      ),
                    );
                  },
                ),
                value: snapshot.data!.any((model) => model.id == currentModel)
                    ? currentModel
                    : snapshot.data!.first.id,
                onChanged: (String? value) {
                  setState(() {
                    currentModel =
                        value; // No need to call toString(), it's already a String?
                  });
                  if (value != null) {
                    modelProvider.setCurrentModel(
                        value); // Only set if the value is not null
                  }
                },
              );
      },
    );
  }
}
